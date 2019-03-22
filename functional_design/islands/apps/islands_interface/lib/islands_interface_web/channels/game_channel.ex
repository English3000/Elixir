defmodule IslandsInterfaceWeb.GameChannel do
  use IslandsInterfaceWeb, :channel

  import Shorthand

  alias IslandsInterfaceWeb.Presence
  alias IslandsEngine.Game.{Server, Supervisor}
  # alias IslandsEngine.DataStructures.Player

  @doc "Sends game state (except opponent's board) to frontend."
  @spec join(topic :: String.t, params :: map, socket :: Socket.t) ::
    {:ok, Socket.t} | {:ok, reply :: map, Socket.t} | {:error, reply :: map}
  def join("game:" <> game, %{"screen_name" => player}, socket) do
    result = track_players(socket, game, player)
             |> register_player?(socket, game, player)
             |> add_player?(game, player)

    case result do
      {:ok, state} -> respond(state, player, socket)

      :error -> players = Presence.list(socket) |> Map.keys |> Enum.join(", ")
                { :error, %{reason: "Player not permitted. Playing: #{players}"} }
    end
  end

  defp track_players(socket, game, player) do
    keys = Presence.list(socket) |> Map.keys
    with    true <- player not in keys and length(keys) < 2,
      saved_game <- :dets.lookup(:game, game),
            true <- saved_game == [] or player?(saved_game, player)
    do
      Presence.track(socket, player, %{time: System.system_time(:seconds)})
      game |> Server.registry_tuple() |> GenServer.whereis
    else
      _ -> :error
    end
  end
  defp player?([{ _key, %{player1: %{name: name1}, player2: %{name: name2}} }], player),
    do: !name2 or player in [name1, name2]

  defp register_player?(result, socket, game, player) do
    case result do
      :error -> :error

         nil -> Supervisor.start_game(game, player) |> register_player?(socket, game, player)

        _pid -> state = Server.lookup_game(m(game, player))
                %{ player1: %{name: name1}, player2: %{name: name2} } = state
                {player not in [name1, name2], state}
    end
  end

  defp add_player?(result, game, player) do
    case result do
      :error         -> :error
      {false, state} -> {:ok, state}
      {true, _state} -> Server.registry_tuple(game) |> Server.join_game(player) # :: {:ok, state} | :error
    end
  end

  defp respond(%{player1: %{name: name1}} = state, player, socket) do
    opp_atom = if player == name1, do: :player2, else: :player1
    state_   = update_in( state, [opp_atom], &Map.delete(&1, :islands) )

    # send(self(), {:after_join, "game_joined", state_, opp_atom})

    {:ok, state_, socket}
  end

  # def handle_info({:after_join, event, state, opp_atom}, socket) do
  #   player_atom = Player.opponent(opp_atom)

  #   %{name: player_name, stage: player_stage} = Map.get(state, player_atom)
  #   %{name: opp_name,    stage: opp_stage}    = Map.get(state, opp_atom)

  #   broadcast! socket, event, %{ player_atom => %{name: player_name, stage: player_stage},
  #                                    opp_atom => %{name: opp_name, stage: opp_stage} }

  #   if player_stage != :joined and
  #      socket |> Presence.list() |> Map.keys() |> length < 2,
  #     do: push socket, "message", %{instruction: "ready"}

  #   {:noreply, socket}
  # end

  @doc "<JS> socket.push(event, payload) => handle_in(event, payload, socket) <EX>"
  @spec handle_in(event :: String.t, payload :: any, socket :: Socket.t) ::
    {:reply, {atom} | {atom, map}, socket :: Socket.t } |
    {:noreply,                     socket :: Socket.t}

  def handle_in("set_islands", payload, %{topic: "game:" <> game} = socket) do
    case Server.registry_tuple(game) |> Server.set_islands(payload) do
         {:ok, player} -> if player.key == :player2 and player.stage == :wait,
                            do: message(socket, "turn")

                          push socket, "islands_set", player
                          {:noreply, socket}

      {:error, reason} -> push socket, "error", m(reason)
                          {:noreply, socket}
    end
  end

  def handle_in("guess_coordinate",
                %{"player"=> key, "row"=> row, "col"=> col},
                %{topic: "game:" <> game} = socket) do
    n = socket
        |> Presence.list
        |> Map.keys
        |> length

    if n == 2 do
      player = String.to_existing_atom(key)
      case Server.registry_tuple(game) |> Server.guess_coordinate(player, row, col) do
        :error       -> push socket, "error", %{reason: "Not your turn."}

        {hit?, won?} ->
          broadcast! socket, "coordinate_guessed", m(row, col, hit: hit?, player_key: player)
          broadcast! socket, "game_status", m(won: won?, winner: player)
      end
    end

    {:noreply, socket}
  end

  @doc "Handles <JS> socket.leave()"
  def terminate(_reason, socket), do: message(socket, "left")

  defp message(socket, instruction), do: broadcast! socket, "message", m(instruction)
end
