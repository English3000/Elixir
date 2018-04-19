defmodule InfoSysTest do
  use ExUnit.Case
  alias InfoSys.Result

  defmodule TestBackend do
    def start_link(query, ref, owner, limit) do
      Task.start_link(__MODULE__, :fetch, [query, ref, owner, limit])
    end

    def fetch("result", ref, owner, _limit) do
      send(owner, {:results, ref, [%Result{backend: "test", text: "result"}]})
    end
    def fetch("none", ref, owner, _limit), do: send(owner, {:results, ref, []})
    def fetch("timeout", ref, owner, _limit) do
      send(owner, {:backend, self()})
      :timer.sleep(:infinity)
    end
    def fetch("crash", _ref, _owner, _limit), do: raise "Crashed"
  end

  test "compute/2 with backend results" do
    assert [%Result{backend: "test", text: "result"}] =
      InfoSys.compute("result", backends: [TestBackend])
  end

  test "compute/2 w/o backend results" do
    assert [] = InfoSys.compute("none", backends: [TestBackend])
  end

  test "compute/2 with timeout returns no results & kills workers" do
    results = InfoSys.compute("timeout", backends: [TestBackend], timeout: 10)

    assert results == []
    assert_receive {:backend, pid}

    ref = Process.monitor(pid)

    assert_receive {:DOWN, ^ref, :process, _pid, _reason}
    refute_received {:DOWN, _,_,_,_}
    refute_received :timed_out
  end

  @tag :capture_log
  test "compute/2 discards backend errors on crash" do
    assert [] = InfoSys.compute("crash", backends: [TestBackend])
    refute_received {:DOWN, _,_,_,_}
    refute_received :timed_out
  end
end
