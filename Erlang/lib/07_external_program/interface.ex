# Makefile: http://www.cs.colby.edu/maxwell/courses/tutorials/maketutor/
# Port examples: https://cultivatehq.com/posts/communicating-with-c-from-elixir-using-ports/,
  # https://stackoverflow.com/questions/44050019/using-elixir-to-talk-to-rust-via-ports-what-am-i-getting-wrong
defmodule Interface do
  def start do
    spawn(fn ->
      Process.flag(:trap_exit, true)
      # doesn't work...
      Port.open({:spawn, "./interface"}, [{:packet, 2}]) |> process()
    end)
    |> Process.register(:interface)
  end

  defp process(port) do
    receive do
      {:call, caller, message} -> send(port, {self(), {:command, encode(message)}})
                                  receive do
                                    {pid, {:data, data}} when port == pid ->
                                      send(caller, {__MODULE__, decode(data)})
                                  end
                                  process(port)

      :stop -> send(port, {self(), :close})
               receive do
                 {pid, :closed} when port == pid -> exit :normal
               end

      {'EXIT', pid, reason} -> exit {:port_terminated, reason}
    end
  end

  def decode([integer]), do: integer

  def sum(x, y),            do: call_port({:sum, x, y})
  def encode({:sum, x, y}), do: [1, x, y]

  def twice(number),            do: call_port({:twice, number})
  def encode({:twice, number}), do: [2, number]

  defp call_port(message) do
    send(__MODULE__, {:call, self(), message})
    receive do
      {__MODULE__, result} -> result
    end
  end

  def stop, do: send(__MODULE__, :stop)
end
