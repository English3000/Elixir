defmodule Erlang.Shell.Client do
  def ls(server_pid) do
    send(server_pid, {self(), :ls})

    receive do
      {pid, file_list} -> match(pid, server_pid, file_list, fn -> ls(server_pid) end)
    end
  end

  def cat(server_pid, file) do
    send(server_pid, {self(), {:cat, file}})

    receive do
      {pid, contents} -> match(pid, server_pid, contents, fn -> cat(server_pid, file) end)
    end
  end

  def write(server_pid, name, contents) do
    send(server_pid, {self(), {:write, name, contents}})

    receive do
      {pid, result} -> match(pid, server_pid, result, fn -> write(server_pid, name, contents) end)
    end
  end

  @spec match(pid, pid, any, function) :: any
  defp match(pid, server_pid, success, failure) do
    case pid == server_pid do
       true -> success
      false -> failure.() # mimics waiting for match
    end
  end
end
