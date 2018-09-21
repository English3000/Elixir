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

  def my_spawn(module, function, args) do
    pid = spawn(module, function, args)
    runtime = :erlang.statistics(:runtime)
    spawn(fn -> supervisor = Process.monitor(pid)
      receive do
        {:DOWN, sup_ref, :process, _pid, reason}
          when sup_ref == supervisor -> IO.inspect reason # could handle as arg w/ macro??
                                        IO.inspect runtime # not different from above
      end
    end)
    pid
  end

  def spawn_then_die(module, function, args, time) do
    pid = spawn(module, function, args)
    receive do
    after
      time -> Process.exit(pid, :kill)
    end
  end

  def spawn_heartbeat(function, name, kill) do
    for helper <- [&register/2, &handle_restart/2],
      do: helper.(function, name)

    heartbeat(name, kill)
  end

  defp register(function, name) do
    spawn(function) |> Process.register(name)
  end

  defp handle_restart(function, name) do
    spawn(fn ->
      supervisor = Process.monitor(name)
      receive do
        {:DOWN, sup_ref, :process, _pid, reason}
          when sup_ref == supervisor -> register(function, name)
      end
    end)
  end

  defp heartbeat(name, kill \\ false) do
    pid = Process.whereis(name)

    receive do
    after
      5_000 -> IO.puts "still running..."

               # validates that `handle_restart` works
               if kill do
                 IO.puts "killed"
                 Process.exit(pid, :kill)
               end

               heartbeat(name)
    end
  end

  # @ 5.
end
