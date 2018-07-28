defmodule IslandsEngine.Game.Server do
  use GenServer, start: {__MODULE__, :start_link, []}, restart: :transient  # start_link/3, start/3
  alias IslandsEngine.Game.Rules
  alias IslandsEngine.DataStructures.{Board, Island, Guesses, Coordinate}

                                # Used by:
  @timeout 60 * 60 * 24 * 1000  #  reply/2
  @players [:player1, :player2] #  Stages
  @errors [:invalid_coord, :invalid_island, :invalid_coord, :unplaced_islands]

  @doc "Start a new game."
  def start_link(player) when is_binary(player),
    do: GenServer.start_link(__MODULE__, player, name: player |> registry_tuple)
  def init(player) do
    send(self(), {:set_state, player})
    {:ok, new_game(player)}
  end
  def handle_info({:set_state, player}, _state) do
    state = case :dets.lookup(:game, player) do
              [{_key, game}] -> game
                          [] -> new_game(player)
            end
    :dets.insert(:game, {player, state})
    {:noreply, state, @timeout}
  end
  def handle_info(:timeout, state),
    do: {:stop, {:shutdown, :timeout}, state}
  def terminate({:shutdown, :timeout}, state),
    do: :dets.delete(:game, state.player1.name); :ok
  def terminate(_reason, _state),
    do: :ok

  # Stages
  def add_player(game, name) when is_binary(name),
    do: GenServer.call(game, {:add_player, name})
  def handle_call({:add_player, name}, _caller, state) do
    with {:ok, rules} <- Rules.check(state.rules, :add_player) do
      state |> join_game(name)
            |> update_rules(rules)
            |> reply(:ok)
    else
      error -> reply(state, error)
    end
  end

  def place_island(game, player, key, row, col) when player in @players,
    do: GenServer.call(game, {:place_island, player, key, row, col})
  def handle_call({:place_island, player, key, row, col}, _caller, state) do
    board = get_board(state, player)
    with {:ok, rules}  <- Rules.check(state.rules, {:place_islands, player}),
         {:ok, coord}  <- Coordinate.new(row, col),
         {:ok, island} <- Island.new(key, coord),
         %{} = board   <- Board.place_island(board, key, island)
    do
      state |> update_board(player, board)
            |> update_rules(rules)
            |> reply(:ok)
    else
      error -> reply(state, error)
    end
  end

  def set_islands(game, player) when player in @players,
    do: GenServer.call(game, {:islands_set, player})
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

  def guess_coordinate(game, player, row, col) when player in @players,
    do: GenServer.call(game, {:guess, player, row, col})
  def handle_call({:guess, player, row, col}, _caller, state) do
      enemy = opponent(player)
    targets = get_board(state, enemy)
    with {:ok, rules} <- Rules.check(state.rules, {:guess, player}),
         {:ok, coord} <- Coordinate.new(row, col),
         {result, forested_island, status, targets} <- Board.player_guess(targets, coord),
         {:ok, rules} <- Rules.check(rules, {:end, status})
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
  @doc "Generates `:via` tuple for a named process."
  def registry_tuple(name),
    do: {:via, Registry, {Registry.Game, name}}
  @doc "Get atom for opposing player. (Assumes only 2 players.)"
  def opponent(:player1), do: :player2
  def opponent(:player2), do: :player1

  defp reply(state, {:error, msg} = result)
    when msg in @errors,
      do: {:reply, result, state, @timeout}
  defp reply(state, result)
    when not is_tuple(result) or
         elem(result, 0) != :error
  do
    if result != :error,
      do: :dets.insert(:game, {state.player1.name, state})
    {:reply, result, state, @timeout}
  end

  defp new_game(player) do
    player1 = %{name: player, board: Board.new, guesses: Guesses.new}
    player2 = %{name: nil,    board: Board.new, guesses: Guesses.new}
    %{player1: player1, player2: player2, rules: Rules.new}
  end
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
