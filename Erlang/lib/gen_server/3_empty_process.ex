defmodule GenServer.EmptyProcess do # L 10012
  # iex> pid = __MODULE__.start
  # iex> send(pid, {:swap, &GenServer.FactorialProcess.process/0})
  # iex> __MODULE__.call(pid, {:factorial, 30})
  def start, do: spawn(&wait/0)

  def wait do
    receive do
      {:swap, server} -> server.()
    end
  end

  def call(pid, request) do
    send(pid, {self(), request})

    receive do
      {caller, reply} when caller == pid -> reply
    end
  end
end

defmodule GenServer.FactorialProcess do
  def process do
    receive do
      {caller, {:factorial, number}} -> send(caller, {self(), factorial(number)})
                                        process()

      {:swap, server} -> server.()
    end
  end

  def factorial(0),            do: 1
  def factorial(n) when n > 0, do: n * factorial(n - 1)
end
