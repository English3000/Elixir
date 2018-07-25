defmodule IslandsEngine.Game do
  use GenServer # start_link/3, start/3
  alias IslandsEngine.Rules
  alias IslandsEngine.DataStructures.{Board, Island, Guesses, Coordinate}

  @players [:player1, :player2]

  def name_process(pid),
    do: {:via, Registry, {Registry.Game, pid}}

  def start(player) when is_binary(player),
    do: GenServer.start_link(__MODULE__, player, name: player |> name_process)
  def init(player) do
    player1 = %{name: player, board: Board.new, guesses: Guesses.new}
    player2 = %{name: nil,    board: Board.new, guesses: Guesses.new}
    {:ok, %{player1: player1, player2: player2, rules: Rules.new} }
  end

  def add_player(game, name) when is_binary(name),
    do: GenServer.call(game, {:add_player, name})
  def handle_call({:add_player, name}, _caller, state) do
    with {:ok, rules} <- Rules.check(state.rules, :add_player) do
      {:reply, :ok, state |> join_game(name) |> update_rules(rules)}
    else
      :error -> {:reply, :error, state}
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
      {:reply, :ok, state |> update_board(player, board) |> update_rules(rules)}
    else
      :error                    -> {:reply, :error, state}
      {:error, :invalid_coord}  -> {:reply, {:error, :invalid_coord}, state}
      {:error, :invalid_island} -> {:reply, {:error, :invalid_island}, state}
      # else, let it crash
    end
  end

  def set_islands(game, player) when player in @players,
    do: GenServer.call(game, {:islands_set, player})
  def handle_call({:islands_set, player}, _caller, state) do
    board = get_board(state, player)
    with {:ok, rules} <- Rules.check(state.rules, {:islands_set, player}),
                 true <- Board.ready?(board) do
      {:reply, {:ok, board}, update_rules(state, rules)}
    else
      :error -> {:reply, :error, state}
       false -> {:reply, {:error, :unplaced_islands}, state}
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
      {:reply, {result, forested_island, status}, state |> update_board(enemy, targets)
                                                        |> update_guesses(player, result, coord)
                                                        |> update_rules(rules) }
    else
      :error                    -> {:reply, :error, state}
      {:error, :invalid_coord}  -> {:reply, {:error, :invalid_coord}, state}
    end
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
  defp opponent(:player1), do: :player2 # assuming only 2 players
  defp opponent(:player2), do: :player1
end
