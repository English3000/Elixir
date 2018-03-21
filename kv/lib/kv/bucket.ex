# defining a class for the app, I think
defmodule KV.Bucket do
  use Agent

  @doc """
  Initializes a bucket/state.
  """
  # It is a convention to define a start_link/1 function that always accepts a list of options.
  def start_link(_options) do
    # We are keeping a map inside the agent to store our keys and values.
    Agent.start_link(fn -> %{} end)
  end

  @doc """
  Inserts `value` into (by `pid`) bucket's (by `key`) state/list.
  """
  def put(pid, key, value) do
    # https://hexdocs.pm/elixir/Map.html#put/3
    # Puts the given value under key in [hash]map.
    # put(map, key, value)
    Agent.update(pid, &Map.put(&1, key, value))
  end

  @doc """
  Returns value of inputted `key` from (by `pid`) bucket, if present.
  Else, returns `nil`.
  """
  def get(pid, key) do
    # https://hexdocs.pm/elixir/Map.html#get/3
    # Gets the value for a specific key in map.
    # If key is present in map with value value, then value is returned. Otherwise, default is returned (which is nil unless specified otherwise).
    # get(map, key, default \\ nil)
    Agent.get(pid, &Map.get(&1, key))
    # returns value OR ELSE nil
  end

  @doc """
  Deletes `key` from (by `pid`) bucket, if present, and returns its value.
  """
  def delete(pid, key) do
    # https://hexdocs.pm/elixir/Map.html#pop/3
    # Returns and removes the value associated with key in map.
    # If key is present in map with value value, {value, new_map} is returned where new_map is the result of removing key from map. If key is not present in map, {default, map} is returned.
    # pop(map, key, default \\ nil)
    Agent.get_and_update(pid, &Map.pop(&1, key))
    # CHECK Agent doc'mtn re: get_and_update/2

    # Agent.get_and_update(pid, fn dict ->
    #   Map.pop(dict, key)
    # end)
  end
end
