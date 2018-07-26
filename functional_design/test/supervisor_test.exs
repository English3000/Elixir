defmodule GameSupervisorTest do
  use ExUnit.Case
  alias IslandsEngine.{Game, GameSupervisor}

  @module "GameSupervisor"
  @title "test"
  # @timeout 15_000

  test @module do
    IO.puts "\nTESTING: " <> @module

    game = start_game(@title)
    via = Game.registry_tuple(@title)
    stop_game(@title, game, via)
  end

  def start_game(title) do
    IO.puts "start_game/1"
    assert {:ok, game} = GameSupervisor.start_game(title)
    IO.puts "."
    game
  end

  def stop_game(title, pid, tuple) do
    IO.puts "stop_game/1"
    assert :ok = GameSupervisor.stop_game(title)
    refute Process.alive?(pid)
    refute GenServer.whereis(tuple)
    IO.puts "."
  end

  # test "timeout" do #works
  #   {:ok, game} = GameSupervisor.start_game(@title)
  #   assert Process.alive?(game)
  #   :timer.sleep(@timeout)
  #   refute Process.alive?(game)
  # end
end
