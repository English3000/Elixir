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

  @doc "Remote Procedure Call: sends request to server && awaits response"
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

  @doc "Spawns a process; if dies, prints data"
  def my_spawn(module, function, args) do
    pid = spawn(module, function, args)

    handle_exit(pid, fn reason -> IO.inspect reason; IO.inspect :erlang.statistics(:runtime) end)

    pid
  end

  @doc "Spawns a process that dies in `time`"
  def spawn_then_die(module, function, args, time) do
    pid = spawn(module, function, args)
    receive do
    after
      time -> Process.exit(pid, :kill)
    end
  end

  @doc "Spawns & registers a process that tail-recursively prints a message every 5 seconds"
  def spawn_heartbeat(function, name, kill) do
    register(name, function)
    |> handle_exit(fn _ -> register(name, function) end)

    heartbeat(name, kill)
  end

  defp register(name, function),
    do: spawn(function) |> Process.register(name)

  defp heartbeat(name, kill \\ false) do
    pid = Process.whereis(name)

    receive do
    after
      5_000 -> IO.puts "still running..."

               # validates that `handle_exit` works
               if kill do
                 IO.puts "killed"
                 Process.exit(pid, :kill)
               end

               heartbeat(name)
    end
  end

  @doc """
  Spawns a monitor + children processes.

  Has an option to restart a child independently or restart all on any crash.
  """
  def spawn_and_monitor(n, restart_all \\ false) do
    pids = for i <- 1..n,
             do: spawn(fn -> IO.inspect(i); loop() end)

    if !restart_all do
      spawn(fn ->
        for pid <- pids,
          do: handle_exit(pid, fn -> IO.inspect pid,    label: "\t restarted"
                                     IO.inspect self(), label: "\t as"

                                     loop() end)
      end)
    else
      spawn(fn ->
              for pid <- pids,
                do: Process.link(pid)

              loop()
            end)
      |> handle_exit(fn -> spawn_and_monitor(n, true) end)
    end

    pids
  end

  @doc "A function that handles process crashes"
  def handle_exit(pid, function) do
    spawn(fn -> supervisor = Process.monitor(pid)
      receive do
        {:DOWN, sup_ref, :process, _pid, reason}
          when sup_ref == supervisor ->
            case :erlang.fun_info(function)[:arity] do
              1 -> function.(reason)
              0 -> function.()
            end
      end
    end)
  end
end
