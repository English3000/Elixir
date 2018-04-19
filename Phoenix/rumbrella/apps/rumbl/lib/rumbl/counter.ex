defmodule Rumbl.Counter do
  use GenServer
  # client; async b/c don't `receive/0` a reply
  def increment(pid), do: GenServer.cast(pid, :increment) #send(pid, :increment)
  def decrement(pid), do: GenServer.cast(pid, :decrement) #send(pid, :decrement)
  # synchronous
  def get_value(pid), do: GenServer.call(pid, :value)
  #   ref = make_ref()
  #
  #   send(pid, {:value, self(), ref})
  #   receive do
  #     {^ref, value} -> value
  #   after timeout -> exit(:timeout)
  #   end
  # end

  # server; recursive
  def start_link(init_state), do: GenServer.start_link(__MODULE__, init_state)
  #   {:ok, spawn_link(fn -> listen(initial_state) end)}
  # end

  # defp listen(value) do
  #   receive do
  #                :increment -> listen(value + 1)
  #                :decrement -> listen(value - 1)
  #     # sends reply to `get_value/2` process
  #     {:value, sender, ref} -> send sender, {ref, value}
  #
  #     listen(value)
  #   end
  # end

  def init(init_state) do
    # Process.send_after(self, :tick, 1000)
    {:ok, init_state}
  end

  # def handle_info(:tick, value) when value <= 0, do: raise "Crashed"
  # def handle_info(:tick, value) do
  #   IO.puts "Count: #{value}"
  #   Process.send_after(self, :tick, 1000)
  #   {:noreply, value - 1}
  # end

  def handle_cast(:increment, value), do: {:noreply, value + 1}
  def handle_cast(:decrement, value), do: {:noreply, value - 1}

  def handle_call(:value, _from, value), do: {:reply, value, value}
end
