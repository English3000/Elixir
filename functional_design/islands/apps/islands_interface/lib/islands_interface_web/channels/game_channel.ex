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
    time = System.system_time(:seconds)
    case length(keys) do
      0 -> case :dets.lookup(:game, game) do
                               [] -> Presence.track(channel, player, m(time))

             [{_key, saved_game}] -> if ( !saved_game.player2.name or
                                           player in [saved_game.player1.name, saved_game.player2.name] ),
                                       do: Presence.track(channel, player, m(time))
           end

      1 -> [{_key, saved_game}] = :dets.lookup(:game, game)
           if hd(keys) != player and
            ( !saved_game.player2.name or
              player in [saved_game.player1.name, saved_game.player2.name] ),
                do: Presence.track(channel, player, m(time))

      2 -> nil
    end

    if Presence.list(channel) |> Map.keys != keys,
      do:   via(game) |> Server.process?,
      else: :error
  end
  defp register_player?(result, channel, game, player) do
    case result do
      :error -> :error

       nil -> Supervisor.start_game(game, player) |> register_player?(channel, game, player)

      _pid -> state = m(game, player) |> Server.lookup_game
              {state.player1.name != player && state.player2.name != player, state}
    end
  end
  defp add_player?(result, game, player) do
    case result do
              :error -> :error
      {false, state} -> {:ok, state}
      {true, _state} -> via(game) |> Server.join_game(player) # :: {:ok, state} | :error
    end
  end
  defp respond(state, player, channel) do
    opp_atom = if state.player1.name == player, do: :player2, else: :player1
    state_ = update_in(state, [opp_atom], &( Map.delete(&1, :islands) ))

    send(self(), {:after_join, "game_joined", state_, Player.opponent(opp_atom)})
    {:ok, state_, channel} ## What happens if a player leaves the game temporarily?
  end
  # defp track_players(_channel, _game, _player, keys) when length(keys) == 2,
  #   do: :error
  # defp track_players(channel, game, player, keys) do
  #   time = System.system_time(:seconds)
  #
  #   case :dets.lookup(:game, game) do
  #                       [] -> Supervisor.start_game(game, player)
  #                             [{_key, saved_game}] = :dets.lookup(:game, game)
  #                             Presence.track(channel, player, m(time))
  #                             {false, saved_game}
  #     [{_key, saved_game}] ->
  #       if player not in keys do
  #         cond do
  #           saved_game.player2.name == nil -> Presence.track(channel, player, m(time))
  #                                             {true, saved_game}
  #           player in [saved_game.player1.name, saved_game.player2.name] == true ->
  #             Presence.track(channel, player, m(time))
  #             {false, saved_game}
  #           true -> :error
  #         end
  #       end
  #   end
  # end
  # NOTE: Room for refactoring...
  def handle_info({:after_join, event, state, player_atom}, channel) do
    opp_atom = Player.opponent(player_atom)
    broadcast! channel, event, %{ player_atom => state[player_atom].stage,
                                     opp_atom => state[opp_atom].stage }

    if state[player_atom].stage != :joined and
       Presence.list(channel) |> Map.keys |> length() < 2,
      do: push channel, "game_left", %{instruction: "ready"}

    {:noreply, channel}
  end

  @doc "<JS> channel.push(event, payload) => handle_in(event, payload, channel) <EX>"
  @spec handle_in(event :: String.t, payload :: any, channel :: Socket.t) ::
    {:reply, {atom} | {atom, map}, channel :: Socket.t } |
    {:noreply,                     channel :: Socket.t}

  def handle_in("set_islands", payload, %{topic: "game:" <> game} = channel) do
    case via(game) |> Server.set_islands(payload) do
      {:ok, player_data} -> push channel, "islands_set", player_data
                            {:noreply, channel}

        {:error, reason} -> push channel, "error", m(reason)
                            {:noreply, channel}
    end
  end

  def handle_in("guess_coordinate", params, %{topic: "game:" <> game} = channel) do
    %{ "player" => player,
          "row" => row,
          "col" => col } = params

    if Presence.list(channel) |> Map.keys |> length == 2 do
      player = String.to_existing_atom(player)
      case via(game) |> Server.guess_coordinate(player, row, col) do
        :error       -> push channel, "error", %{reason: "Not your turn."}

        {hit?, won?} ->
          broadcast! channel, "coordinate_guessed", m(row, col, hit: hit?, player_key: player)
          broadcast! channel, "game_status", m(won: won?, winner: player)
      end
    end

    {:noreply, channel}
  end

  @doc "Handles <JS> channel.leave()"
  def terminate(_reason, channel),
    do: broadcast! channel, "game_left", %{instruction: "left"}

  defp via(game),
    do: Server.registry_tuple(game)
end
