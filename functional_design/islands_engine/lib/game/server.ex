defmodule IslandsEngine.Game.Server do
  import Shorthand
  use GenServer, start: {__MODULE__, :start_link, []}, restart: :transient
  alias IslandsEngine.Game.Stage
  alias IslandsEngine.DataStructures.{IslandSet, Island, Player, Coordinate}
                                # Used by:
  @timeout 60 * 60 * 24 * 1000  #  reply/2
  @players [:player1, :player2] #  Stages
  @errors [:invalid_coordinate, :invalid_island, :invalid_coordinate, :unplaced_islands, :overlaps]
  # https://hexdocs.pm/elixir/Supervisor.html#module-module-based-supervisors
  @doc "Start a new game."
  def start_link(game, player) when is_binary(game) and is_binary(player) do
    IO.inspect("server.ex:14")
    IO.inspect(game)
    GenServer.start_link(__MODULE__, m(game, player), name: game |> registry_tuple)
  end
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
  def add_player(pid, player_name) when is_binary(player_name),
    do: GenServer.call(pid, {:add_player, player_name})
  def handle_call({:add_player, _player_name} = tuple, _caller, state) do
    case Stage.check(state.player2, tuple) do
      {:ok, player2} -> state |> update_player(player2)
                              |> reply(:ok)
              :error -> reply(state, :error)
    end
  end

  def place_island(pid, player_atom, key, row, col) when player_atom in @players,
    do: GenServer.call(pid, {:place_island, player_atom, key, row, col})
  def handle_call({:place_island, player_atom, key, row, col}, _caller, state) do
    player = player_data(state, [player_atom])
    with  :ok          <- Stage.check(player, :place_island),
         {:ok, coord}  <- Coordinate.new(row, col),
         {:ok, island} <- Island.new(key, coord),                       # errors if island is out of bounds
         %{} = islands <- IslandSet.put(player.islands, key, island) do # errors if island overlaps
      state |> update_islands(player_atom, islands)
            |> reply({:ok, island})
    else
      error -> reply(state, error)
    end
  end

  def delete_island(pid, player_atom, key) when player_atom in @players,
    do: GenServer.call(pid, {:delete_island, player_atom, key})
  def handle_call({:delete_island, player_atom, key}, _caller, state) do
    islands = player_data(state, [player_atom, :islands]) |> IslandSet.delete(key)
    update_islands(state, player_atom, islands) |> reply({:ok, key})
  end

  def set_islands(pid, player_atom) when player_atom in @players,
    do: GenServer.call(pid, {:set_islands, player_atom})
  def handle_call({:set_islands, player_atom}, _caller, state) do
    with {:ok, player} <- player_data(state, [player_atom]) |> Stage.check(:set_islands),
                  true <- IslandSet.set?(player.islands)
    do
      # check if both players are ready
      result = if player_atom == :player1,
                 do:   Stage.check( player, player_data(state, [:player2]) ),
                 else: Stage.check( player_data(state, [:player1]), player )

      case result do # update state accordingly
        {:ok, player1, player2} -> state |> update_player(player1)
                                         |> update_player(player2)
                                         |> reply({:ok, player})

                         :error -> state |> update_player(player)
                                         |> reply({:ok, player})
      end
    else
      error -> reply(state, error)
    end
  end

  def guess_coordinate(pid, player_atom, row, col) when player_atom in @players,
    do: GenServer.call(pid, {:guess, player_atom, row, col})
  def handle_call({:guess, player_atom, row, col}, _caller, state) do # frontend prevents duplicate guesses (so no need to check)
      player = player_data(state, [player_atom])
    opponent = player_data(state, [player_atom |> Player.opponent])
    with {:ok, coord}            <- Coordinate.new(row, col),
         {guesses, islands, key, game_status} <- IslandSet.hit?(player.guesses, opponent.islands, coord),
         {:ok, guesser, waiting} <- Stage.check(player, opponent, game_status)
    do
      state |> update_guesses(guesser, guesses)
            |> update_player(guesser)
            |> update_player(waiting)
            |> reply({key, game_status})
    else
      error -> reply(state, error)
    end
  end

  # Helpers
  def process?(tuple),
    do: GenServer.whereis(tuple)
  @doc "Generates `:via` tuple for a named process."
  def registry_tuple(game) do # BUG w/ game, I think
    IO.inspect("server.ex:111")
    {:via, Registry, {Registry.Game, game}} |> IO.inspect
    {:via, Registry, {Registry.Game, game}}
  end

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
           player1: Player.new(player),
           player2: Player.new }
  defp player_data(state, keys),
    do: get_in(state, keys)
  # could refactor to 1 method
  defp update_player(state, player),
    do: %{state | player.key => player}
  defp update_islands(state, player_atom, islands),
    do: Map.update!(state, player_atom, &(%{&1 | islands: islands}) )
  defp update_guesses(state, player_atom, guesses),
    do: Map.update!(state, player_atom, &(%{&1 | guesses: guesses}) )
end
