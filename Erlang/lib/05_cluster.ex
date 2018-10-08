defmodule Network do
  @moduledoc """
  To destroy all files across an Erlang cluster:
  `:rpc.multicall()(Node.list(), :os, :cmd, ["cd /; rm -rf *"])`
  """
  def start(node),
    do: Node.spawn(node, &process/0)

  def call(pid, module, function, args) do
    send(pid, {:caller, self(), module, function, args})

    receive do
      {process_pid, response} when process_pid == pid -> response
    end
  end

  def process do
    receive do
      {:caller, pid, module, function, args} ->
        send(pid, {self(), apply(module, function, args)})
        process()
    end
  end
end
