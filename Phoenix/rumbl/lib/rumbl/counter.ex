defmodule Rumbl.Counter do
  # client; async b/c don't `receive/0` a reply
  def increment(pid), do: send(pid, :increment)
  def decrement(pid), do: send(pid, :decrement)

  def get_value(pid, timeout \\ 5000) do
    ref = make_ref()

    send(pid, {:value, self(), ref})
    # synchronous
    receive do
      {^ref, value} -> value
    after timeout -> exit(:timeout)
    end
  end

  # server; recursive
  defp listen(value) do
    receive do
                 :increment -> listen(value + 1)
                 :decrement -> listen(value - 1)
      # sends reply to `get_value/2` process
      {:value, sender, ref} -> send sender, {ref, value}

      listen(value)
    end
  end

  def start_link(initial_state) do
    {:ok, spawn_link(fn -> listen(initial_state) end)}
  end
end
