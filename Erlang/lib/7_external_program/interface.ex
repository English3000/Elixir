# NIFs in Elixir: https://spin.atomicobject.com/2015/03/16/elixir-native-interoperability-ports-vs-nifs/
defmodule Interface do # @ Location 6272
  def start do
    Process.register(:interface, spawn(fn ->
      Process.flag(:trap_exit, true)
      Port.open({:spawn, "./interface"}, [{:packet, 2}]) |> process()
    end))
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
