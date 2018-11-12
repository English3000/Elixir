# NOTE: Room for refactoring...
defmodule IslandsInterfaceWeb.GameChannel do
  # https://hexdocs.pm/phoenix/Phoenix.Channel.html
  # https://hexdocs.pm/phoenix/testing_channels.html
  import Shorthand
  use IslandsInterfaceWeb, :channel
  alias IslandsInterfaceWeb.Presence
  alias IslandsEngine.Game.{Server, Supervisor}
  alias IslandsEngine.DataStructures.Player

  @doc "Sends game state (except opponent's board) to frontend."
  @spec join(topic :: String.t, params :: map, channel :: Socket.t) ::
    {:ok, Socket.t} | {:ok, reply :: map, Socket.t} | {:error, reply :: map}
  def join("game:" <> game, %{"screen_name" => player}, channel) do
    result = track_players(channel, game, player)
             |> register_player?(channel, game, player)
             |> add_player?(game, player)

    case result do
      {:ok, state} -> respond(state, player, channel)

      :error -> players = Presence.list(channel) |> Map.keys |> Enum.join(", ")
                { :error, %{reason: "Player not permitted. Playing: #{players}"} }
    end
  end
  # Also restores game on crash.
  defp track_players(channel, game, player) do
    keys = Presence.list(channel) |> Map.keys
    with    true <- player not in keys and length(keys) < 2,
      saved_game <- :dets.lookup(:game, game),
            true <- saved_game == [] or player?(saved_game, player)
    do
      Presence.track(channel, player, %{time: System.system_time(:seconds)})
      game |> Server.registry_tuple() |> GenServer.whereis
    else
      _ -> :error
    end
  end
  defp player?([{_key, game}], player),
    do: !game.player2.name or player in [game.player1.name, game.player2.name]

  defp register_player?(result, channel, game, player) do
    case result do
      :error -> :error

         nil -> Supervisor.start_game(game, player) |> register_player?(channel, game, player)

        _pid -> state = Server.lookup_game(m(game, player))
                %{ player1: %{name: name1}, player2: %{name: name2} } = state
                {player not in [name1, name2], state}
    end
  end

  defp add_player?(result, game, player) do
    case result do
              :error -> :error
      {false, state} -> {:ok, state}
      {true, _state} -> Server.registry_tuple(game) |> Server.join_game(player) # :: {:ok, state} | :error
    end
  end

  defp respond(%{player1: %{name: name1}} = state, player, channel) do
    opp_atom = if player == name1, do: :player2, else: :player1
    state_ = update_in( state, [opp_atom], &Map.delete(&1, :islands) )

    send(self(), {:after_join, "game_joined", state_, opp_atom})
    {:ok, state_, channel}
  end

  def handle_info({:after_join, event, state, opp_atom}, channel) do
    player_atom = Player.opponent(opp_atom)

    %{name: player_name, stage: player_stage} = Map.get(state, player_atom)
    %{name: opp_name,    stage: opp_stage}    = Map.get(state, opp_atom)

    broadcast! channel, event, %{ player_atom => %{name: player_name, stage: player_stage},
                                     opp_atom => %{name: opp_name, stage: opp_stage} }

    if player_stage != :joined and
       channel |> Presence.list() |> Map.keys() |> length < 2,
      do: push channel, "message", %{instruction: "ready"}

    {:noreply, channel}
  end

  @doc "<JS> channel.push(event, payload) => handle_in(event, payload, channel) <EX>"
  @spec handle_in(event :: String.t, payload :: any, channel :: Socket.t) ::
    {:reply, {atom} | {atom, map}, channel :: Socket.t } |
    {:noreply,                     channel :: Socket.t}

  def handle_in("set_islands", payload, %{topic: "game:" <> game} = channel) do
    case Server.registry_tuple(game) |> Server.set_islands(payload) do
         {:ok, player} -> if player.key == :player2 and player.stage == :wait,
                            do: message(channel, "turn")

                          push channel, "islands_set", player
                          {:noreply, channel}

      {:error, reason} -> push channel, "error", m(reason)
                          {:noreply, channel}
    end
  end

  def handle_in("guess_coordinate",
                %{"player"=> key, "row"=> row, "col"=> col},
                %{topic: "game:" <> game} = channel) do
    n = channel
        |> Presence.list
        |> Map.keys
        |> length

    if n == 2 do
      player = String.to_existing_atom(key)
      case Server.registry_tuple(game) |> Server.guess_coordinate(player, row, col) do
        :error       -> push channel, "error", %{reason: "Not your turn."}

        {hit?, won?} ->
          broadcast! channel, "coordinate_guessed", m(row, col, hit: hit?, player_key: player)
          broadcast! channel, "game_status", m(won: won?, winner: player)
      end
    end

    {:noreply, channel}
  end

  @doc "Handles <JS> channel.leave()"
  def terminate(_reason, channel), do: message(channel, "left")

  defp message(channel, instruction), do: broadcast! channel, "message", m(instruction)
end
