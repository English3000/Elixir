# TODO: write tests ~ https://hexdocs.pm/phoenix/testing_channels.html
defmodule IslandsInterfaceWeb.GameChannel do
  import Shorthand
  use IslandsInterfaceWeb, :channel
  alias IslandsInterfaceWeb.Presence
  alias IslandsEngine.Game.{Server, Supervisor}

  @doc "Sends game state (except opponent's board) to frontend."
  @spec join(topic :: String.t, params :: map, channel :: Socket.t) ::
    {:ok, Socket.t} |
    {:ok, reply :: map, Socket.t} |
    {:error, reply :: map}
  def join("game:" <> game, %{"screen_name" => player_name}, channel) do
    ## NOTE: Perfect use case for Monad.
    functions = [ channel, # first result
                  &track_players/3,
                  &register_player?/3,
                  &add_player?/3,
                  &get_state/3 ]
    call = fn function, result -> function.(result, game, player_name) end
    case Enum.reduce(functions, call) do
      {:error, reason} -> {:error, %{reason: append_players(reason, channel)}}

         ## What happens if a player leaves the game temporarily? (handle foundational issues first)
         {:ok, state}  -> send(self(), {:after_join, "game_joined", state})
                          {:ok, channel}  # How will game receive proper instruction to display?
    end
  end
  defp append_players(msg, channel) do
    case msg do
      "Game at capacity." -> msg <> " Players: #{Presence.list(channel) |> Map.keys |> Enum.join(", ")}."
                        _ -> msg
    end
  end
  def handle_info({:after_join, event, state}, channel) do
    broadcast! channel, event, state
    {:noreply, channel}
  end
  # Also restores game on crash.
  defp track_players(channel, game, player) do
    keys = Presence.list(channel) |> Map.keys
    time = System.system_time(:seconds) # unnecessary w/ no match
    case length(keys) do
      0 -> case :dets.lookup(:game, game) do
                               [] -> Presence.track(channel, player, m(time))

             [{_key, saved_game}] -> Presence.track(channel, saved_game.player1.name, m(time))
                                     if saved_game.player2.name != nil,
                                       do: Presence.track(channel, saved_game.player2.name, m(time))
           end

      1 -> if hd(keys) != player,
             do: Presence.track(channel, player, m(time))
    end

    via(game) |> Server.process?
  end
  defp register_player?(result, game, player) do
    case result do
       nil -> new_game(game, player) |> register_player?(game, player)

      {:error, reason} -> {:error, reason}

      _pid -> state = m(game, player) |> Server.lookup_game
              {state.player1.name != player && state.player2.name != player, state}
    end
  end
  defp new_game(game, player),
    do: Supervisor.start_game(game, player)
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
         :ok -> m(game, player) |> Server.lookup_game |> remove_board(:player1)
       tuple -> tuple
    end
  end
  defp remove_board(state, opp_atom) when is_atom(opp_atom) do
    opp_data = state |> Map.get(opp_atom) |> Map.delete(:board)
    {:ok, Map.put(state, opp_atom, opp_data)}
  end

  @doc "<JS> channel.push(event, payload) => handle_in(event, payload, channel) <EX>"
  @spec handle_in(event :: String.t, payload :: any, channel :: Socket.t) ::
    {:reply, {status :: atom} | {status :: atom, response :: map}, channel :: Socket.t } |
    {:noreply,                                                     channel :: Socket.t}
  def handle_in("get_state", %{player: player} = payload, channel),
    do: {:reply, payload |> Server.lookup_game |> remove_board(player), channel}
  defp remove_board(state, player) when is_binary(player) do
    cond do
      state.player1.name == player -> remove_board(state, :player2)
      state.player2.name == player -> remove_board(state, :player1)
                              true -> {:error, %{reason: "Not playing."}}
    end
  end

  # To decouple logic, sending larger payload
  # Just send island??
  def handle_in("place_island", %{"player"=> player,"island"=> island,"row"=> row,"col"=> col}, channel) do
        player_atom = String.to_existing_atom(player)
        island_atom = String.to_existing_atom(island)
    "game:" <> game = channel.topic
    case via(game) |> Server.place_island(player_atom, island_atom, row, col) do
        {:ok, islands} -> {:reply,    {:ok, islands},   channel}
      {:error, reason} -> {:reply, {:error, m(reason)}, channel} # :overlaps | :invalid_coordinate
    end
  end

  def handle_in("remove_island", %{"player"=> player,"island"=> island}, channel) do
        player_atom = String.to_existing_atom(player)
        island_atom = String.to_existing_atom(island)
    "game:" <> game = channel.topic
    case via(game) |> Server.remove_island(player_atom, island_atom) do
      {:ok, islands} -> {:reply, {:ok, islands}, channel}
                   _ -> {:reply, {:error, %{reason: "Island not removed."}}, channel}
    end
  end

  def handle_in("set_islands", player, %{topic: "game:" <> game} = channel) do
    case via(game) |> Server.set_islands( String.to_existing_atom(player) ) do
         {:ok, _board}  -> broadcast! channel, "islands_set", player <> " islands set."
                          {:reply, :ok, channel}
      {:error, reason} -> {:reply, {:error, m(reason)}, channel}
    end
  end

  def handle_in("guess_coordinate", params, %{topic: "game:" <> game} = channel) do
    %{ "player" => player,
          "row" => row,
          "col" => col } = params

    player = String.to_existing_atom(player)
    case via(game) |> Server.guess_coordinate(player, row, col) do ## REFACTOR
      {result, island, status} -> hit = if result == :hit, do: true, else: false
                                  result = m(hit, island, status)
                                  # Can just `result` be broadcasted?
                                  broadcast! channel, "guessed_coordinate", m(player, row, col, result)
                                  {:noreply, channel}

      :error                   -> {:reply, {:error, %{reason: "Not your turn."}}, channel}

      {:error, reason}         -> {:reply, {:error, m(reason)}, channel}
    end
  end

  defp via(game),
    do: Server.registry_tuple(game)
end
