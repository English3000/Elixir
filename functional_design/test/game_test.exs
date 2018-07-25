defmodule GameTest do
  use ExUnit.Case
  alias IslandsEngine.{Game, Rules}

  @player1 "Frank"
  @player2 "Dweezil"

  test "API" do
    IO.puts "start_link/1"
    assert {:ok, game} = Game.start_link(@player1)
    IO.puts "."

    assert :error = Game.guess_coordinate(game, :player1, 1,1)
    IO.puts "RULE: guesses not allowed"

    IO.puts "add_player/2"
    Game.add_player(game, @player2)
    state = :sys.get_state(game)
    assert     @player2 = state.player2.name
    assert :has_players = state.rules.state
    IO.puts "."

    IO.puts "place_island/1"
    Game.place_island(game, :player1, :square, 1,1)
    state = :sys.get_state(game)
    assert Map.fetch!(state.player1.board, :square)
    IO.puts "."

    assert {:error, :invalid_coord} = Game.place_island(game, :player1, :dot, -3,3)
    IO.puts "+ handles invalid coordinates"

    assert {:error, :invalid_island} = Game.place_island(game, :player1, :wrong, 3,3)
    IO.puts "+ handles invalid islands"

    IO.puts "set_islands/2"
    assert {:error, :unplaced_islands} = Game.set_islands(game, :player1)
    IO.puts "+ handles unplaced islands"

    Game.place_island(game, :player1, :atoll, 1,3)
    Game.place_island(game, :player1, :dot, 2,3)
    Game.place_island(game, :player1, :L, 1,5)
    Game.place_island(game, :player1, :S, 4,1)

    assert {:ok, _board} = Game.set_islands(game, :player1)
    assert :has_players = state.rules.state
    IO.puts "."

    state = :sys.replace_state(game, fn state ->
      %{state | rules: %Rules{state: {:turn, :player1} }}
    end)
    assert {:turn, :player1} = state.rules.state
    assert :error = Game.place_island(game, :player1, :dot, 5,5)
    IO.puts "RULE: turns enforced"

    IO.puts "guess_coordinate/4"
    assert {:miss, :none, false} = Game.guess_coordinate(game, :player1, 9,9)
    assert :error = Game.guess_coordinate(game, :player1, 9,9)
    assert {:hit, :none, false} = Game.guess_coordinate(game, :player2, 1,1)
    IO.puts "."
  end
end
