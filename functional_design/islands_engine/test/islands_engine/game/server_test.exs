defmodule Game.ServerTest do
  use ExUnit.Case
  alias IslandsEngine.Game.{Server, Rules, Supervisor}

  @module "Game.{Server, Rules}"
  @player1 "Frank"
  @player2 "Dweezil"
  @coupled_island :square
  @coupled_row 1
  @coupled_col 1

  test @module do
    IO.puts "\nTESTING: " <> @module

    start_link(@player1)
    |> guessing_rule(:player1, 1,1)
    |> add_player(@player2)
    |> place_island(:player1, @coupled_island, @coupled_row, @coupled_col)
    |> invalid_coord(:player1, :dot, -3,3)   # error test
    |> invalid_island(:player1, :wrong, 3,3) # error test
    |> unplaced_islands(:player1)            # error test
    |> set_islands(:player1)           # coupled island
    |> turns_rule
    |> guess_coordinate(:player1, 9,9) # coupled row, col

    Supervisor.stop_game(@player1)
  end

  # Game
  defp start_link(player) do
    IO.puts "start_link/1"
    assert {:ok, game} = Server.start_link(player)
    IO.puts "."
    game
  end

  defp add_player(game, player) do
    IO.puts "add_player/2"
    Server.add_player(game, player)
    state = :sys.get_state(game)
    assert player == state.player2.name
    assert :players_set = state.rules.state
    IO.puts "."
    game
  end

  # DRY?
  defp place_island(game, player, island, row, col) do
    IO.puts "place_island/1"
    assert :ok = Server.place_island(game, player, island, row, col)
    state = :sys.get_state(game)
    assert Map.fetch!(state.player1.board, island)
    IO.puts "."
    game
  end
  defp invalid_coord(game, player, island, row, col) do
    assert {:error, :invalid_coordinate} = Server.place_island(game, player, island, row, col)
    IO.puts "+ handles invalid coordinates"
    game
  end
  defp invalid_island(game, player, island, row, col) do
    assert {:error, :invalid_island} = Server.place_island(game, player, island, row, col)
    IO.puts "+ handles invalid islands"
    game
  end

  defp unplaced_islands(game, player) do
    IO.puts "set_islands/2"
    assert {:error, :unplaced_islands} = Server.set_islands(game, player)
    IO.puts "+ handles unplaced islands"
    game
  end

  defp set_islands(game, player) do
    setup_board(game, player)

    assert {:ok, _board} = Server.set_islands(game, player)
    state = :sys.get_state(game)
    assert :players_set = state.rules.state
    IO.puts "."
    game
  end
  defp setup_board(game, player) do
    Server.place_island(game, player, :atoll, 1,3)
    Server.place_island(game, player, :dot, 2,3)
    Server.place_island(game, player, :L, 1,5)
    Server.place_island(game, player, :S, 4,1)
  end

  defp guess_coordinate(game, player, row, col) do
    IO.puts "guess_coordinate/4"
    assert {:miss, :none, false} = Server.guess_coordinate(game, player, row, col)
    assert :error = Server.guess_coordinate(game, player, row, col)
    assert {:hit, :none, false} = Server.guess_coordinate(game, Server.opponent(player), @coupled_row, @coupled_col)
    IO.puts "."
    game
  end

  # Rules
  defp guessing_rule(game, player, row, col) do
    IO.puts "Rule: can't guess during board-setting phase"
    assert :error = Server.guess_coordinate(game, player, row, col)
    IO.puts "."
    game
  end

  defp turns_rule(game) do
    IO.puts "Rule: can't place island during turn-taking phase"
    new_state = :sys.replace_state(game, fn state ->
      %{state | rules: %Rules{state: {:turn, :player1} }}
    end)
    assert {:turn, :player1} = new_state.rules.state
    assert :error = Server.place_island(game, :player1, :dot, 5,5)
    IO.puts "."
    game
  end
end
