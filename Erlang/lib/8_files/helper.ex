# {:ok, pid} = File.open "lib/8_files/ex.dat", [:read]

defmodule Helper do # @ L 6757
  def print_by_line(pid) do
    case IO.binread(pid, :line) do
      :eof -> :eof
      line -> IO.inspect(line)
              print_by_line(pid)
    end
  end
  # h.s., WORKS!
  @doc "Writes a `list` of Elixir terms to `file`"
  def write(list, path) do # `File.write` is more efficient b/c only 1 op
    {:ok, pid} = File.open("lib/8_files/" <> path, [:write])
    Enum.each( list, &(IO.inspect(pid, &1, [])) )
    File.close(pid)
  end

  def file_info(path) do
    case File.stat(path) do
      {:ok, info} -> {info.type, info.size} # :filelib.size/1, :filelib.is_dir/1
                _ -> :error
    end
  end

  def dir_info(path) do
    {:ok, dirs} = File.ls
    Enum.sort(dirs) |> Enum.map( &({&1, file_info(&1)}) )
  end

  # works! -- can implement with processes
  def search(dir, regex, recurse) do
    search(dir, regex, recurse, &([&1|&2]), []) |> Enum.reverse
  end

  def search(dir, regex, recurse, function, acc) do
    case File.ls(dir) do
      {:ok, dirs} -> search(dirs, dir, regex, recurse, function, acc)
      {:error, _} -> acc
    end
  end

  def search([file | tail], dir, regex, recurse, function, acc) do # could parallelize recursing thru list
    path = Path.join([dir, file])
    new_acc = file_type(path) |> search(path, regex, recurse, function, acc)
    search(tail, dir, regex, recurse, function, new_acc)
  end

  def file_type(path) do
    with {:ok, info} <- File.stat(path),
         info.type in [:regular, :directory] do
      info.type
    else
      _ -> :error
    end
  end

  def search([], _dir, _regex, _recurse, _function, acc),
    do: acc

  def search(:regular, path, regex, recurse, function, acc) do
    case Regex.run(regex, path, capture: :none) do
       [] -> function.(path, acc)
      nil -> acc
    end
  end

  def search(:directory, path, regex, recurse, function, acc) do
    case recurse do
       true -> search(path, regex, recurse, function, acc) # CDs into next dir -- could parallelize here
      false -> acc
    end
  end

  def search(:error, path, regex, recurse, function, acc),
    do: acc
end

# Helper.print_by_line(pid)
#
# File.close "lib/8_files/ex.dat"

# list = :code.which(:file) |> to_string |> Path.split
# path = Enum.take(list, length(list)-2) |> Path.join()
# :file.consult "/../../.." <> path <> "/src/file.erl" -- errors
