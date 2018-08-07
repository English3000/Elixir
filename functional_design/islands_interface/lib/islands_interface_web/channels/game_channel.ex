defmodule IslandsInterfaceWeb.GameChannel do
  @moduledoc """
  Create a handle_in/3 clause for starting a new game (via Game.Supervisor), and
                              for each event stage defined in the Game.Server

  Module indicates success or failure of action on frontend,
  but as is, does not respond with data.

  REDESIGN: Include rules in response so can exclude other player's data.
  """
  # TODO: write tests ~ https://hexdocs.pm/phoenix/testing_channels.html
  import Shorthand
  use IslandsInterfaceWeb, :channel
  alias IslandsInterfaceWeb.Presence
  alias IslandsEngine.Game.{Server, Supervisor}

  @doc """
  Sends game state to frontend.

  Phoenix.Channel.join/3 => {:ok, state - opp_board, channel}
   SERVES SIMILARLY TO
  GenServer.init/1 => {:ok, state}
  """
  @spec join(topic :: String.t, params :: map, channel :: Socket.t) ::
    {:ok, Socket.t} |
    {:ok, reply :: map, Socket.t} |
    {:error, reply :: map}
  def join("game:" <> game, %{"screen_name" => player}, channel) do
    ## NOTE: Perfect use case for Monad.
    functions = [ channel, # first result
                  &handle_restart/3,
                  &register_player?/3,
                  &add_player?/3,
                  &get_state/3 ]
    call = fn function, result -> function.(result, game, player) end
    case Enum.reduce(functions, call) do
         {:ok, state}  -> {:ok, state, channel}
      {:error, reason} -> {:error, %{reason: append_players(reason, channel)}}
    end
  end
  defp append_players(msg, channel) do
    case msg do
      "Game at capacity." -> msg <> " Players: #{Presence.list(channel) |> Map.keys |> Enum.join(", ")}."
                        _ -> msg
    end
  end

  @doc "Restores game upon crash or Phoenix.Presence upon refresh."
  defp handle_restart(channel, game, player) do
    with                    0 <- Presence.list(channel) |> Map.keys |> length,
         [{_key, saved_game}] <- :dets.lookup(:game, game)
    do
      Presence.track(channel, saved_game.player1.name, %{time: System.system_time(:seconds)})
      if saved_game.player2.name != nil,
        do: Presence.track(channel, saved_game.player2.name, %{time: System.system_time(:seconds)})
    end

    via(game) |> Server.process?
  end
  defp register_player?(result, game, player) do
    case result do
       nil -> new_game(game, player) |> register_player?(game, player)

      {:error, reason} -> {:error, reason}

      _pid -> state = m(game, player) |> Server.lookup_game
              {state.player1.name != player, state}
    end
  end
  defp add_player?(result, game, player) do
    case result do
      {false, state} -> remove_board(state, :player2)
      { true, state} -> via(game) |> Server.add_player(player)
               error -> error
    end
  end
  defp get_state(result, game, player) do
    case result do
      :error -> {:error, "Game at capacity."}

         :ok -> send(self(), {:after_join, player})
                m(game, player) |> Server.lookup_game |> remove_board(:player1)

       tuple -> tuple
    end
  end

  defp new_game(game, player),
    do: Supervisor.start_game(game, player)
  defp remove_board(state, opp_atom) do
    opp_data = state |> Map.get(opp_atom) |> Map.delete(:board)
    {:ok, Map.put(state, opp_atom, opp_data)}
  end
  # defp get_game(game, player) do
  #   case via(game) |> Server.process? do # bug when using `if !`
  #     nil -> new_game(game, player)
  #       _ -> register_player(game, player)
  #   end
  # end
  #
  # defp new_game(game, player) do
  #   case Supervisor.start_game(game, player) do
  #     {:error, reason} -> {:error, m(reason)}
  #        {:ok, _pid}   -> register_player(game, player, :player2)
  #   end
  # end
  #
  # defp register_player(game, player) do
  #   state = m(game, player) |> Server.lookup_game
  #   case state.player1 == player do
  #     false -> add_player(game, player)
  #      true -> opp_data = state |> Map.get(:player2) |> Map.delete(:board)
  #              {:ok, Map.put(state, :player2, opp_data)}
  #   end
  # end
  #
  # defp add_player(game, player) do
  #   case via(game) |> Server.add_player(player) do
  #     :ok              -> get_state(game, player, :player1)
  #     :error           -> {:error, %{reason: "Game at capacity."}}
  #     {:error, reason} -> {:error, m(reason)}
  #   end
  # end
  #
  # @doc "Gets game state minus opponent's board."
  # defp get_state(game, player, opp_atom) do
  #   send(self(), {:after_join, player})
  #
  #   state    = m(game, player) |> Server.lookup_game
  #   opp_data = state |> Map.get(opp_atom) |> Map.delete(:board)
  #
  #   {:ok, Map.put(state, opp_atom, opp_data)}
  # end

  @doc "Tracks newly joined players using Phoenix.Presence"
  def handle_info({:after_join, player}, channel) do
    {:ok, _} = Presence.track(channel, player, %{time: System.system_time(:seconds) |> inspect}) ##
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
  # @doc "Broadcasts list of current players to browser clients."
  # def handle_in("show_subscribers", _payload, channel) do
  #   broadcast! channel, "subscribers", Presence.list(channel) # 3rd arg = response to all clients
  #   {:noreply, channel}
  # end

  # No need to return anything until islands set.
  # Mutable frontend can handle placement logic.
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
      {:error, reason} -> {:reply, {:error, m(reason)}, channel} # :overlaps | :invalid_coordinate
    end
  end

  def handle_in("set_islands", player, channel) do
    player_atom = String.to_existing_atom(player)
    "game:" <> game = channel.topic
    case via(game) |> Server.set_islands(player_atom) do
         {:ok, board}  -> broadcast! channel, "islands_set", %{player: player_atom}
                          {:reply, {:ok, board}, channel}

      {:error, reason} -> {:reply, {:error, m(reason)}, channel}
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
                                  # Can just `result` be broadcasted?
                                  broadcast! channel, "guessed_coordinate", m(player, row, col, result)
                                  {:noreply, channel}

      :error                   -> {:reply, {:error, %{player: player, reason: "Not your turn."}}, channel}

      {:error, reason}         -> {:reply, {:error, m(player, reason)}, channel}
    end
  end

  defp via(game),
    do: Server.registry_tuple(game)
end
