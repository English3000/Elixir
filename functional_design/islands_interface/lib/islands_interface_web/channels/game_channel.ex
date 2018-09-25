defmodule IslandsInterfaceWeb.GameChannel do  ## TODO: write tests ~ https://hexdocs.pm/phoenix/testing_channels.html
  import Shorthand
  use IslandsInterfaceWeb, :channel
  alias IslandsInterfaceWeb.Presence
  alias IslandsEngine.Game.{Server, Supervisor}
  @moduledoc "Need error broadcasts too..."

  @doc "Sends game state (except opponent's board) to frontend."
  @spec join(topic :: String.t, params :: map, channel :: Socket.t) ::
       {:ok, Socket.t} |
       {:ok, reply :: map, Socket.t} |
    {:error, reply :: map}  ## NOTE: Perfect use case for Monad.
  def join("game:" <> game, %{"screen_name" => player_name}, channel) do
    functions = [&track_players/3, &register_player?/3, &add_player?/3, &get_state/3]
         call = fn function, result -> function.(result, game, player_name) end
    case Enum.reduce(functions, channel, call) do
      {:error, reason} -> {:error, %{reason: append_players(reason, channel)}}
         {:ok, state}  -> send(self(), {:after_join, "game_joined", state})
                          {:ok, state, channel}  ## What happens if a player leaves the game temporarily?
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

      2 -> nil
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
      {false, state} -> remove_islands(state, ( if state.player1.name == player,
                                                  do:   :player2,
                                                  else: :player1 ))
      { true, state} -> via(game) |> Server.add_player(player)
               error -> error
    end
  end
  defp remove_islands(state, opp_atom) when is_atom(opp_atom),
    do: {:ok, update_in(state, [opp_atom], &( Map.delete(&1, :islands) ))}
  # Removed `case` expressions && `:reply` tuples
  @doc "<JS> channel.push(event, payload) => handle_in(event, payload, channel) <EX>"
  @spec handle_in(event :: String.t, payload :: any, channel :: Socket.t) ::
    {:reply, {status :: atom} | {status :: atom, response :: map}, channel :: Socket.t } |
    {:noreply,                                                     channel :: Socket.t}
  # def handle_in("place_island", %{"player"=> player,"island"=> island,"row"=> row,"col"=> col}, %{topic: "game:" <> game} = channel) do
  #   via(game) |> Server.place_island(String.to_atom(player), String.to_atom(island), row, col)
  #   {:noreply, channel}
  # end
  #
  # def handle_in("delete_island", %{"player"=> player,"island"=> island}, %{topic: "game:" <> game} = channel) do
  #   via(game) |> Server.delete_island(String.to_atom(player), String.to_atom(island))
  #   {:noreply, channel}
  # end

  # NOTE: Update to handle full islandset
  def handle_in("set_islands", player, %{topic: "game:" <> game} = channel) do
    via(game) |> Server.set_islands(String.to_existing_atom(player))
    {:noreply, channel}
  end

  def handle_in("guess_coordinate", params, %{topic: "game:" <> game} = channel) do
    %{ "player" => player,
          "row" => row,
          "col" => col } = params

    player = String.to_existing_atom(player)
    via(game) |> Server.guess_coordinate(player, row, col)
    {:noreply, channel}
  end

  defp via(game),
    do: Server.registry_tuple(game)
end
