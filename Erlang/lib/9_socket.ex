# https://elixir-lang.org/getting-started/mix-otp/task-and-gen-tcp.html#echo-server
defmodule Socket do
  def start_server do
    {:ok, socket} = :gen_tcp.listen(2345, [:binary, packet: 4, reuseaddr: true, active: true])
    # accept(socket)                # sequential
    spawn(fn -> accept(socket) end) # concurrent -- controlling process (if closed, entire socket closes)
  end

  def accept(socket) do
    {:ok, socket} = :gen_tcp.accept(socket)

    spawn(fn -> accept(socket) end)
    # socket |> process() |> accept()  # to accept next connection (sequential)
    process(socket)
  end

  def process(socket) do
    receive do
      {:tcp, port, binary} when port == socket ->
        IO.inspect(binary, label: "Server received binary")

        :gen_tcp.send(socket, binary)
        process(socket)

      {:tcp_closed, port} when port == socket -> IO.puts("Socket closed")
    end
  end


  def start_client(string) do
    {:ok, socket} = :gen_tcp.connect('localhost', 2345, [:binary, packet: 4])

    :ok = :gen_tcp.send(socket, string)
    receive do
      {:tcp, port, binary} when port == socket ->
        IO.inspect(binary, label: "Client received binary")
        :gen_tcp.close(socket)
    end
  end
end
