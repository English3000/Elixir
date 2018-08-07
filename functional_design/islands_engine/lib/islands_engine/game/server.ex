defmodule IslandsEngine.Game.Server do
  @moduledoc """
  `game` argument can be PID or `:via` registry_tuple
  """
  import Shorthand
  use GenServer, start: {__MODULE__, :start_link, []}, restart: :transient  # start_link/3, start/3
  alias IslandsEngine.Game.Rules
  alias IslandsEngine.DataStructures.{Board, Island, Guesses, Coordinate}

                                # Used by:
  @timeout 60 * 60 * 24 * 1000  #  reply/2
  @players [:player1, :player2] #  Stages
  @errors [:invalid_coordinate, :invalid_island, :invalid_coordinate, :unplaced_islands, :overlaps]
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
  def add_player(pid, player) when is_binary(player),
    do: GenServer.call(pid, {:add_player, player})
  def handle_call({:add_player, player}, _caller, state) do
    with {:ok, rules} <- Rules.check(state.rules, :add_player) do
      state |> join_game(player)
            |> update_rules(rules)
            |> reply(:ok)
    else
      error -> reply(state, error)
    end
  end

  def place_island(pid, player, key, row, col) when player in @players,
    do: GenServer.call(pid, {:place_island, player, key, row, col})
  def handle_call({:place_island, player, key, row, col}, _caller, state) do
    board = get_board(state, player)
    with {:ok, rules}  <- Rules.check(state.rules, {:place_islands, player}),
         {:ok, coord}  <- Coordinate.new(row, col),
         {:ok, island} <- Island.new(key, coord),                # errors if island is out of bounds
         %{} = board   <- Board.place_island(board, key, island) # errors if island overlaps
    do
      state |> update_board(player, board)
            |> update_rules(rules)
            |> reply(:ok)
    else
      error -> reply(state, error)
    end
  end

  def set_islands(pid, player) when player in @players,
    do: GenServer.call(pid, {:islands_set, player})
  def handle_call({:islands_set, player}, _caller, state) do
    board = get_board(state, player)
    with {:ok, rules} <- Rules.check(state.rules, {:islands_set, player}),
                 true <- Board.ready?(board) do
      state |> update_rules(rules)
            |> reply({:ok, board})
    else
      error -> reply(state, error)
    end
  end

  def guess_coordinate(pid, player, row, col) when player in @players,
    do: GenServer.call(pid, {:guess, player, row, col})
  def handle_call({:guess, player, row, col}, _caller, state) do
      enemy = Rules.opponent(player) ## @ modifying server response state to exclude other player's board
    targets = get_board(state, enemy)
    with {:ok, rules} <- Rules.check(state.rules, {:guess, player}),
         {:ok, coord} <- Coordinate.new(row, col),
         {result, forested_island, status, targets} <- Board.player_guess(targets, coord),
         {:ok, rules} <- Rules.check(rules, {:status, status})
    do
      state |> update_board(enemy, targets)
            |> update_guesses(player, result, coord)
            |> update_rules(rules)
            |> reply({result, forested_island, status})
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

  defp reply(state, {:error, msg} = result)
    when msg in @errors, # redunant/coupled?
      do: {:reply, result, state, @timeout}
  defp reply(state, result)
    when not is_tuple(result) or
         elem(result, 0) != :error
  do
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
           rules: Rules.new,
           player1: new_player(player),
           player2: new_player(nil) }
  defp new_player(player),
    do: %{ name: player,
           board: Board.new, 
           guesses: Guesses.new }
  defp join_game(state, player),
    do: put_in(state.player2.name, player)
  defp update_rules(state, rules),
    do: %{state | rules: rules}
  defp update_board(state, player, board),
    do: Map.update!(state, player, &(%{&1 | board: board}) )
  defp get_board(state, player),
    do: Map.get(state, player).board
  defp update_guesses(state, player, result, coord),
    do: update_in(state[player].guesses, &( Guesses.add(&1, result, coord) ))
end
