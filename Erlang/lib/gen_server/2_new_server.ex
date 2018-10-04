defmodule GenServer.NewServer do
  alias GenServer.Server

  def all_names,
    do: Server.call(:name_server, :all_names)

  def add(key, value),
    do: Server.call(:name_server, {:add, key, value})

  def delete(key),
    do: Server.call(:name_server, {:delete, key})

  def find(key),
    do: Server.call(:name_server, {:find, key})


  def init, do: %{}

  def handle(:all_names, state),
    do: {Map.keys(state), state}

  def handle({:add, key, value}, state),
    do: {:ok, Map.put(state, key, value)}

  def handle({:delete, key}, state),
    do: {:ok, Map.delete(state, key)}

  def handle({:find, key}, state),
    do: {Map.get(state, key), state}
end
