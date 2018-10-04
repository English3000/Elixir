defmodule GenServer.Server do
  alias GenServer.Process

  def add(key, value),
    do: Process.call(:name_server, {:add, key, value})

  def find(key),
    do: Process.call(:name_server, {:find, key})

  # callback routines
  def init,
    do: %{}

  def handle({:add, key, value}, state),
    do: {:ok, Map.put(state, key, value)}

  def handle({:find, key}, state),
    do: {Map.get(state, key), state}
end
