defmodule Game.SupervisorTest do
  use ExUnit.Case
  alias IslandsEngine.Game.{Server, Supervisor}

  @module "Game.Supervisor"
  @title "test"
  # @timeout 15_000

  test @module do
    IO.puts "\nTESTING: " <> @module

    game = start_game(@title)
    via = Server.registry_tuple(@title)
    new_game = crash_game(game, via)
    stop_game(@title, new_game, via)
  end

  def start_game(title) do
    IO.puts "start_game/1"
    assert {:ok, game} = Supervisor.start_game(title)
    IO.puts "."
    game
  end

  def crash_game(pid, tuple) do
    IO.puts "starts new game upon crash"
    assert Process.exit(pid, :crash_game)
    :timer.sleep 1
    assert new_pid = GenServer.whereis(tuple)
    assert pid != new_pid
    IO.puts "."
    new_pid
  end

  def stop_game(title, pid, tuple) do
    IO.puts "stop_game/1"
    assert :ok = Supervisor.stop_game(title)
    refute Process.alive?(pid)
    refute GenServer.whereis(tuple)
    IO.puts "."
  end

  # test "timeout" do #works
  #   {:ok, game} = Supervisor.start_game(@title)
  #   assert Process.alive?(game)
  #   :timer.sleep(@timeout)
  #   refute Process.alive?(game)
  # end
end
