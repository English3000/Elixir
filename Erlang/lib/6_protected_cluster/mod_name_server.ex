defmodule ModNameServer do
  @moduledoc """
  This protocol is the middle-man protocol that
  is obeyed by both the client code and the server code.

  The socket middle-man code is explained in more detail in ​
  `lib_chan_mm: The Middle Man`.
  """

  def start(proxy_pid, _client_args, _conf_args),
    do: process(proxy_pid)

  defp process(pid) do
    receive do
      {:chan, caller_pid, {:store, key, value}} when caller_pid == pid ->
        NameServer.store(key, value)
        process(pid)

      {:chan, caller_pid, {:lookup, key}} when caller_pid == pid ->
        send(pid, {:send, NameServer.lookup(key)})
        process(pid)

      {:chan_closed, caller_pid} when caller_pid == pid ->
        true
    end
  end
end
