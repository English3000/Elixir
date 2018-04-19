defmodule InfoSys do
  @backends [InfoSys.Wolfram]

  defmodule Result do
    defstruct score: 0, text: nil, url: nil, backend: nil
  end

  def start_link(backend, query, ref, owner, limit) do
    backend.start_link(query, ref, owner, limit)
  end

  def compute(query, options \\ []) do
    limit = options[:limit] || 10
    backends = options[:backends] || @backends

    backends |> Enum.map(&spawn_query(&1, query, limit))
             |> await_results(options)
             |> Enum.sort(&(&1.score >= &2.score))
             |> Enum.take(limit)
  end

  defp spawn_query(backend, query, limit) do
    ref = make_ref() #for query
    options = [backend, query, ref, self(), limit]

    {:ok, pid} = Supervisor.start_child(InfoSys.Supervisor, options)
    monitor = Process.monitor(pid)

    {pid, monitor, ref}
  end

  defp await_results(children, options) do
    timeout = options[:timeout] || 5000
    timer = Process.send_after(self(), :timed_out, timeout)

    results = await_result(children, [], :infinity)
    cleanup(timer)

    results
  end

  defp await_result([head | tail], acc, timeout) do
    {pid, monitor, ref} = head
    receive do
      {:results, ^ref, results}                  -> Process.demonitor(monitor, [:flush])
                                                      await_result(tail, results ++ acc, timeout)
      {:DOWN, ^monitor, :process, ^pid, _reason} -> await_result(tail, acc, timeout)
      :timed_out                                 -> kill(pid, monitor)
                                                      await_result(tail, acc, 0)
    after
      timeout -> kill(pid, monitor)
                   await_result(tail, acc, 0)
    end
  end
  defp await_result([], acc, _), do: acc

  defp kill(pid, monitor) do
    Process.demonitor(monitor, [:flush])
    Process.exit(pid, :kill)
  end

  defp cleanup(timer) do
    :erlang.cancel_timer(timer)
    receive do
      :timed_out -> :ok
    after
      0 -> :ok
    end
  end
end
