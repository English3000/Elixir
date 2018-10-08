# https://elixir-lang.org/getting-started/mix-otp/task-and-gen-tcp.html#echo-server
defmodule Socket.TCP do
  def start_server do
    {:ok, socket} = :gen_tcp.listen(2345, [:binary, packet: 4, reuseaddr: true, active: true])
    # accept(socket)                # sequential
    spawn(fn -> accept(socket) end) # concurrent -- controlling process (if closed, entire socket closes)
  end

  def accept(socket) do
    {:ok, socket} = :gen_tcp.accept(socket)
    # socket |> process() |> accept()  # sequnetial -- to accept next connection
    spawn(fn -> accept(socket) end)
    process(socket)
  end

  def process(socket) do
    receive do
      {:tcp, id, binary} when id == socket ->
        IO.inspect(binary, label: "Server received binary")

        :gen_tcp.send(socket, binary)
        process(socket)

      {:tcp_closed, id} when id == socket -> IO.puts("Socket closed")
    end
  end


  def start_client(string) do
    {:ok, socket} = :gen_tcp.connect('localhost', 2345, [:binary, packet: 4])

    :ok = :gen_tcp.send(socket, string)
    receive do
      {:tcp, id, binary} when id == socket ->
        IO.inspect(binary, label: "Client received binary")
        :gen_tcp.close(socket)
    end
  end
end

defmodule Socket.TCP.HybridBlocking do
  def start_server(option) do # true | false | :once
    {:ok, socket} = :gen_tcp.listen(2345, [:binary, packet: 4, reuseaddr: true, active: option])
    {:ok, socket} = :gen_tcp.accept(socket)
    process(socket)
  end

  def process(socket) do
    # BLOCKING
    # case :gen_tcp.recv(socket, 0) do
    #   {:ok, data}       ->
    #   {:error, :closed} ->
    # end

    # HYBRID, use this
    # receive do
    #   {:tcp, id, data} when id == socket ->
    #     :inet.setopts(socket, [active: :once])
    #     process(socket)
    #
    #   {:tcp_closed, socket} ->
    # end
  end
end
