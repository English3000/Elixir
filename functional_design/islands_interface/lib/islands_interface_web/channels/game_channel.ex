defmodule IslandsInterfaceWeb.GameChannel do
  @moduledoc """
  Create a handle_in/3 clause for starting a new game (via Game.Supervisor), and
                              for each event stage defined in the Game.Server

  Module indicates success or failure of action on frontend,
  but as is, does not respond with data.
  """
  # TODO: write tests ~ https://hexdocs.pm/phoenix/testing_channels.html
  import Shorthand
  use IslandsInterfaceWeb, :channel
  alias IslandsInterfaceWeb.Presence
  alias IslandsEngine.Game.{Server, Supervisor}

  @doc """
  Phoenix.Channel.join/3 => {:ok, channel}
   SERVES SIMILARLY TO
  GenServer.init/1 => {:ok, state}
  """
  @spec join(topic :: String.t, params :: map, channel :: Socket.t) ::
    {:ok, Socket.t} |
    {:ok, reply :: map, Socket.t} |
    {:error, reply :: map}
  def join("game:" <> _player, %{"screen_name" => screen_name}, channel) do
    case authorized?(channel, screen_name) do
       true -> send(self(), {:after_join, screen_name})
               {:ok, channel} # should send game state

      false -> {:error, %{reason: "Game at capacity OR you've already joined."}}
    end

  end

  defp authorized?(channel, screen_name),
    do: game_size(channel) < 2 and
        not playing?(channel, screen_name)

  defp game_size(channel),
    do: channel |> Presence.list
                |> Map.keys
                |> length

  defp playing?(channel, screen_name),
    do: channel |> Presence.list
                |> Map.has_key?(screen_name)

  @doc "Tracks newly joined players using Phoenix.Presence"
  def handle_info({:after_join, screen_name}, channel) do
    {:ok, _} = Presence.track(channel, screen_name, %{time: System.system_time(:seconds) |> inspect})
    {:noreply, channel}
  end

  @doc "Broadcasts list of current players to browser clients."
  def handle_in("show_subscribers", _payload, channel) do
    broadcast! channel, "subscribers", Presence.list(channel) # 3rd arg = response to all clients
    {:noreply, channel}
  end

  @doc """
  IN CLIENT (JS)
  push({} = channel, {message: ""} = payload) =>
  IN SERVER (EX)
  """
  @spec handle_in(event :: String.t, payload :: any, channel :: Socket.t) ::
    {:reply, {status :: atom} | {status :: atom, response :: map}, channel :: Socket.t } |
    {:noreply,                                                     channel :: Socket.t}
  def handle_in("new_game", _payload, channel) do # payload = 2nd arg given to .push on frontend
    "game:" <> player = channel.topic
    case Supervisor.start_game(player) do
         {:ok, _pid}   -> {:reply, :ok, channel}
      {:error, reason} -> {:reply, {:error, %{reason: inspect(reason)} }, channel}
    end
  end

  def handle_in("add_player", player, channel) do
    case via(channel.topic) |> Server.add_player(player) do
      :ok              -> broadcast! channel, "player_added", %{message: player <> " joined game."}
                          {:noreply, channel}

      :error           -> {:reply, :error, channel}

      {:error, reason} -> {:reply, {:error, %{reason: inspect(reason)} }, channel}
    end
  end

  def handle_in("place_island", payload, channel) do
    %{ "player" => player,
       "island" => island,
          "row" => row,
          "col" => col } = payload

    player_atom = String.to_existing_atom(player)
    island_atom = String.to_existing_atom(island)

    case via(channel.topic) |> Server.place_island(player_atom, island_atom, row, col) do
      :ok -> {:reply, :ok, channel}
        _ -> {:reply, :error, channel}
    end
  end

  def handle_in("set_islands", player, channel) do
    player_atom = String.to_existing_atom(player)
    case via(channel.topic) |> Server.set_islands(player_atom) do
      {:ok, board} -> broadcast! channel, "islands_set", %{player: player_atom}
                      {:reply, {:ok, m(board)}, channel}

                 _ -> {:reply, :error, channel}
    end
  end

  def handle_in("guess_coordinate", params, channel) do
    %{ "player" => player,
          "row" => row,
          "col" => col } = params

    player = String.to_existing_atom(player)
    case via(channel.topic) |> Server.guess_coordinate(player, row, col) do
      {result, island, status} -> hit = if result == :hit, do: true, else: false
                                  result = m(hit, island, status)
                                  broadcast! channel, "guessed_coordinate", m(player, row, col, result)
                                  {:noreply, channel}

      :error                   -> {:reply, {:error, %{player: player, reason: "Not your turn."}}, channel}

      {:error, reason}         -> {:reply, {:error, m(player, reason)}, channel}
    end
  end

  defp via("game:" <> player),
    do: Server.registry_tuple(player)
end
