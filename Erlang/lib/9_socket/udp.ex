defmodule Socket.UDP do
  @moduledoc """
  UDP is a connectionless protocol, which means
  the client does not have to establish a connection to the server
  before sending it a message.

  This means that UDP is well suited for applications
  where large numbers of clients send small messages to a server.

  "Programming Erlang"
  """

  def start,
    do: spawn(fn -> start_server(4000) end)

  def start_server(port) do
    {:ok, socket} = :gen_udp.open(port, [:binary])
    process(socket)
  end

  def process(socket) do
    receive do
      {:udp, id, host, port, binary} when id == socket ->
        IO.inspect(binary)
        reply = String.to_integer(binary) |> factorial |> to_string
        :gen_udp.send(socket, host, port, reply)
        process(socket)
    end
  end

  defp factorial(0), do: 1
  defp factorial(n), do: n * factorial(n - 1)


  def start_client(request) do
    {:ok, socket} = :gen_udp.open(0, [:binary])
    # ref = make_ref() # && send it
    :ok = :gen_udp.send(socket, 'localhost', 4000, to_string(request))

    reply =
      receive do
        {:udp, id, _,_, binary} when id == socket -> {:ok, binary}
      after
        2000 -> :error
      end

    :gen_udp.close(socket)

    reply
  end
end
