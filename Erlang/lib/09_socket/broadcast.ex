defmodule Socket.Broadcast do
  @moduledoc """
  Here we need two ports, one to send the broadcast and the other to listen for answers.
  We’ve chosen port 5000 to send the broadcast request and 6000 to listen for broadcasts

  Only the process performing a broadcast opens port 5000, but
  all machines in the network call `broadcast:listen()`, which
  opens port 6000 and listens for broadcast messages.
  """
  def send(io_list) do
    {:ok, [broadaddr: ip]} = :inet.ifget('eth0', [:broadaddr])
    {:ok, socket} = :gen_udp.open(5000, [broadcast: true])
    :gen_udp.send(socket, ip, 6000, io_list)
    :gen_udp.close(socket)
  end

  def listen do
    {:ok, _} = :gen_udp.open(6000)
    process()
  end

  def process do
    receive do
      message -> IO.inspect message
                 process()
    end
  end
end
