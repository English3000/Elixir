defmodule ConcurrencyTemplate do
  def start,
    do: spawn(__MODULE__, :loop, [])

  @doc "loop/0 doesn't send a response back"
  def loop do
    receive do
      msg -> IO.inspect(msg, label: "Received")
             loop()
    end
  end

  def rpc(pid, request) do
    send(pid, {self(), request})

    receive do
      {new_pid, response} when new_pid == pid -> response
    end
  end

  # Exercises
  def start(atom, function) do
    spawn(function) |> Process.register(atom)
    :erlang.statistics(:runtime)
  end

  # passing 1 message to many processes
  #   is faster than sending a few messages to a few processes
  def start_ring(n) do
    pids = for i <- 1..n,
             do: start()

    Enum.reduce(pids, fn next_pid, pid -> send(pid, pid); next_pid end)
    :erlang.statistics(:runtime)
  end
end
