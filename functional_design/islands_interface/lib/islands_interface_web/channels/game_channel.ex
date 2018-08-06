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
  Sends game state to frontend.

  Phoenix.Channel.join/3 => {:ok, state - rules, channel}
   SERVES SIMILARLY TO
  GenServer.init/1 => {:ok, state}
  """
  @spec join(topic :: String.t, params :: map, channel :: Socket.t) ::
    {:ok, Socket.t} |
    {:ok, reply :: map, Socket.t} |
    {:error, reply :: map}
  def join("game:" <> game, %{"screen_name" => player}, channel) do
    if authorized?(channel, player) do
       case get_game(game, player) do
            {:ok, state}  -> {:ok, state, channel}
         {:error, reason} -> {:error, m(reason), channel}
       end
    else
      {:error, %{reason: "Game at capacity."}, channel}
    end
  end

  defp authorized?(channel, player),
    do: game_size(channel) < 2 and
        not playing?(channel, player)

  defp game_size(channel),
    do: channel |> Presence.list
                |> Map.keys
                |> length

  defp playing?(channel, player),
    do: channel |> Presence.list
                |> Map.has_key?(player)

  defp get_game(game, player) do
    case via(game) |> Server.process? do # bug when using `if !`
      nil -> new_game(game, player)
        _ -> register_player(game, player)
    end
  end

  defp new_game(game, player) do
    case Supervisor.start_game(game, player) do
      {:error, reason} -> {:error, m(reason)}

         {:ok, _pid}   -> send(self(), {:after_join, player})
                          {:ok, m(game, player) |> Server.lookup_game |> Map.delete(:rules)}
    end
  end

  defp register_player(game, player) do
    state = m(game, player) |> Server.lookup_game
    if state.player1 == player,
      do:   {:ok, Map.delete(state, :rules)},
      else: add_player(game, player)
  end

  defp add_player(game, player) do
    case via(game) |> Server.add_player(player) do
      :ok              -> send(self(), {:after_join, player})
                          {:ok, m(game, player) |> Server.lookup_game |> Map.delete(:rules)}
      :error           -> {:error, %{reason: "Game at capacity."}}
      {:error, reason} -> {:error, m(reason)}
    end
  end

  @doc "Tracks newly joined players using Phoenix.Presence"
  def handle_info({:after_join, player}, channel) do
    {:ok, _} = Presence.track(channel, player, %{time: System.system_time(:seconds) |> inspect}) ##
    {:noreply, channel}
  end

  @doc "Broadcasts list of current players to browser clients."
  ## haven't arrived at this use case yet
    ## maybe, if fail to join...
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
  # NOTE: Functionality moved to `get_game/2`, error-handling to `join/3`
  # def handle_in("new_game", player, channel) do # payload = 2nd arg given to .push on frontend
  #   "game:" <> game = channel.topic
  #   case Supervisor.start_game(game, player) do
  #        {:ok, _pid}   -> {:reply, :ok, channel}
  #     {:error, reason} -> {:reply, {:error, %{reason: inspect(reason)} }, channel}
  #   end
  # end

  # def handle_in("add_player", player, channel) do
  #   "game:" <> game = channel.topic
  #   case via(game) |> Server.add_player(player) do
  #     :ok              -> broadcast! channel, "player_added", %{message: player <> " joined game."}
  #                         {:noreply, channel}
  #
  #     :error           -> {:reply, :error, channel} ## no error msg
  #
  #     {:error, reason} -> {:reply, {:error, %{reason: inspect(reason)} }, channel}
  #   end
  # end

  def handle_in("place_island", payload, channel) do
    %{ "player" => player,
       "island" => island,
          "row" => row,
          "col" => col } = payload

    player_atom = String.to_existing_atom(player)
    island_atom = String.to_existing_atom(island)
    "game:" <> game = channel.topic

    case via(game) |> Server.place_island(player_atom, island_atom, row, col) do
      :ok -> {:reply, :ok, channel}
        _ -> {:reply, :error, channel}
    end
  end

  def handle_in("set_islands", player, channel) do
    player_atom = String.to_existing_atom(player)
    "game:" <> game = channel.topic
    case via(game) |> Server.set_islands(player_atom) do
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
    "game:" <> game = channel.topic
    case via(game) |> Server.guess_coordinate(player, row, col) do
      {result, island, status} -> hit = if result == :hit, do: true, else: false
                                  result = m(hit, island, status)
                                  broadcast! channel, "guessed_coordinate", m(player, row, col, result)
                                  {:noreply, channel}

      :error                   -> {:reply, {:error, %{player: player, reason: "Not your turn."}}, channel}

      {:error, reason}         -> {:reply, {:error, m(player, reason)}, channel}
    end
  end

  defp via(game),
    do: Server.registry_tuple(game)
end
