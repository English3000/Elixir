defmodule KV.Registry do
  use GenServer
  # REVIEW GenServer API: https://hexdocs.pm/elixir/GenServer.html

  # Client API

  @doc """
  Starts registry.
  """
  def start_link(options) do
    GenServer.start_link(__MODULE__, :ok, options)
    # arg's: module w/ server callbacks, init. arg's, options for custom'zn
  end

  @doc """
  Looks up bucket pid by `name` (in `server`).

  Returns `{:ok, pid}` if the bucket exists, `:error` otherwise.
  """
  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  @doc """

  """
  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end

  @doc """
  Stops the registry.
  """
  def stop(server) do
    GenServer.stop(server)
  end

  # Server callbacks
  def init(:ok) do
    names = %{}
    refs = %{}
    {:ok, names, refs}
    # state: `name -> pid`; dict: `ref -> name`
  end

  def handle_call({:lookup, name}, _from, {names, _} = state) do
    # arg's: request, pid, current server state
    {:reply, Map.fetch(names, name), state}
    # Map.fetch equiv. to names[name], except returns {:ok, value}
    # last arg. returned = new state; second = reply to client
  end

  # in real app, would implement as sync. call
  def handle_cast({:create, name}, {names, refs}) do
    if Map.has_key?(names, name) do
      {:noreply, {names, refs}}
    else
      {:ok, pid} = KV.Bucket.start_link([])
      ref = Process.monitor(pid)
      # put(map, key, value)
      refs = Map.put(refs, ref, name)
      names = Map.put(names, name, pid)

      {:noreply, {names, refs}}
    end
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    # Map.pop/2 returns {popped value, new map}
    {name, refs} = Map.pop(refs, ref)
    # Map.delete/2 returns {new map}
    names = Map.delete(names, name)
    {:noreply, {names, refs}}
  end

  # Discards any unknown message.
  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
