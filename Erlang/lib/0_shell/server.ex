defmodule Erlang.Shell.Server do
  def start(dir),
    do: spawn(fn -> loop(dir) end)

  def loop(dir) do
    receive do
      {client_pid, :ls         } -> send(client_pid, {self(), File.ls(dir)}) # :file.list_dir(dir)
      {client_pid, {:cat, file}} -> send(client_pid, {self(), Path.join(dir, file) |> File.read}) # :filename.join(dir, file), :file.read_file(path)
      {client_pid, {:write, name, contents}} -> 
                                    send(client_pid, {self(), File.write(name, contents)})
    end

    loop(dir)
  end
end
