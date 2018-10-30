defmodule IslandsEngine.Game.Server do
  import Shorthand
  use GenServer, start: {__MODULE__, :start_link, []}, restart: :transient
  alias IslandsEngine.Game.Stage
  alias IslandsEngine.DataStructures.{IslandSet, Player, Coordinate}
                                # Used by:
  @timeout 60 * 60 * 24 * 1000  #  reply/2
  @players [:player1, :player2] #  Stages
  @errors [:invalid_coordinate, :invalid_island, :invalid_coordinate, :unplaced_islands, :overlapping_islands]
  # https://hexdocs.pm/elixir/Supervisor.html#module-module-based-supervisors
  @doc "Start a new game."
  def start_link(game, player) when is_binary(game) and is_binary(player),
    do: GenServer.start_link(__MODULE__, m(game, player), name: game |> registry_tuple)
  @doc "Sets process's initial state, or stops process on timeout."
  def init(payload) do
    send(self(), {:set_state, payload})
    {:ok, new_game(payload)}
  end
  def handle_info({:set_state, payload}, _state),
    do: {:noreply, lookup_game(payload), @timeout}
  def handle_info(:timeout, state),
    do: {:stop, {:shutdown, :timeout}, state}
  def terminate({:shutdown, :timeout}, state),
    do: :dets.delete(:game, state.game); :ok
  def terminate(_reason, _state),
    do: :ok

  # Stages
  def join_game(pid, player_name),
    do: GenServer.call(pid, {:join_game, player_name})
  def handle_call({:join_game, player_name} = tuple, _caller, state) do
    key = cond do
            state.player2.name in [player_name, nil] -> :player2
            state.player1.name == player_name        -> :player1
                                                true -> nil
          end

    with         false <- !key,
         {:ok, player} <- Map.get(state, key) |> Stage.check(tuple) do
      state_ = Map.put(state, key, player)
      reply(state_, {:ok, state_})
    else
      _ -> reply(state, :error)
    end
  end

  def set_islands(pid, payload),
    do: GenServer.call(pid, {:set_islands, payload})
  def handle_call({:set_islands, %{"player"=> player, "islands"=> island_set}}, _caller, state) do
    with {_mapset, islands} <- IslandSet.validate(island_set) do
      saved_player = Map.fetch!(state, String.to_existing_atom(player))
      player = %{saved_player | stage: :ready, islands: islands}
      # Check if other player is ready.
      result = if player.key == :player1,
                 do:   Stage.check(player, Map.fetch!(state, :player2)),
                 else: Stage.check(Map.fetch!(state, :player1), player)

      case result do
        {:ok, player1, player2} -> state |> Map.put(player1.key, player1)
                                         |> Map.put(player2.key, player2)
                                         |> reply({:ok, player})

                         :error -> state |> Map.put(player.key, player)
                                         |> reply({:ok, player})
      end
    else
      _ -> reply(state, {:error, :overlapping_islands})
    end
  end

  # frontend prevents duplicate guesses
  def guess_coordinate(pid, player_atom, row, col) when player_atom in @players,
    do: GenServer.call(pid, {:guess, player_atom, row, col})
  def handle_call({:guess, player_atom, row, col}, _caller, state) do
      player = Map.fetch!(state, player_atom)
    opponent = Map.fetch!(state, player_atom |> Player.opponent)
    with {guesses, hit?, won?} <- IslandSet.hit?(player.guesses, opponent.islands, %Coordinate{row: row, col: col}),
       {:ok, guesser, waiting} <- Stage.check(player, opponent, won?)
    do
      guesser = Map.put(guesser, :guesses, guesses)

      state |> Map.put(guesser.key, guesser)
            |> Map.put(waiting.key, waiting)
            |> reply({hit?, won?})
    else
      error -> reply(state, error)
    end
  end

  # Helpers
  def process?(tuple),
    do: GenServer.whereis(tuple)
  @doc "Generates `:via` tuple for a named process."
  def registry_tuple(game),
    do: {:via, Registry, {Registry.Game, game}}

  defp reply(state, {:error, msg} = result) when msg in @errors, # redunant/coupled?
    do: {:reply, result, state, @timeout}
  defp reply(state, result) when not is_tuple(result) or elem(result, 0) != :error do
    if result != :error, do: :dets.insert(:game, {state.game, state})
    {:reply, result, state, @timeout}
  end

  def lookup_game(%{game: game} = payload) do
    state = case :dets.lookup(:game, game) do
              [{_key, saved_game}] -> saved_game
                                [] -> new_game(payload)
            end
    :dets.insert(:game, {game, state}); state
  end
  defp new_game(%{game: game, player: player}),
    do: %{ game: game,
           player1: Player.new(player),
           player2: Player.new }
end
