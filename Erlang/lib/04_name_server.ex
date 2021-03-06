defmodule NameServer do # @ Stage 4 (TRY Stage 3 one morning)
  @moduledoc """
  To test: `mix test test/name_server_test.exs`

  To start a named session: `iex --sname <name>`

  For multi-node testing: `:rpc.call(:"<session_name>", <module>, <function_atom>, [<args>])`
  """

  # @spec start :: true
  def start,
    do: Process.register(spawn(&process/0), :name_server)

  @doc """
      iex> NameServer.store({:location, :joe}, "Stockholm")
      true
  """
  # @spec store(key, value) :: true
  def store(key, value),
    do: call({:store, key, value})

  @doc """
      iex> NameServer.lookup({:location, :joe})
      {:ok, "Stockholm"}

      iex> NameServer.lookup(:atom)
      nil
  """
  # @spec lookup(key) :: {:ok, value} | nil
  def lookup(key),
    do: call({:lookup, key})

  defp call(query) do # sends message from caller process to name_server process
    send(:name_server, {self(), query})

    receive do
      {:name_server, reply} -> reply
    end
  end

  # Each process has a map that can be globally written to (known as the 'process dictionary').
  defp process do # process that infinitely waits/loops
    receive do
      {client, {:store, key, value}} -> Process.put(key, {:ok, value})
                                        send(client, {:name_server, true})
                                        process()

      {client, {:lookup, key}}       -> send(client, {:name_server, Process.get(key)})
                                        process()
    end
  end
end
