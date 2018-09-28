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
  def write(list, file) do # `File.write` is more efficient b/c only 1 op
    {:ok, pid} = File.open("lib/8_files/" <> file, [:write])
    Enum.each( list, &(IO.inspect(pid, &1, [])) )
    File.close(pid)
  end
end

# Helper.print_by_line(pid)
#
# File.close "lib/8_files/ex.dat"

# list = :code.which(:file) |> to_string |> Path.split
# path = Enum.take(list, length(list)-2) |> Path.join()
# :file.consult "/../../.." <> path <> "/src/file.erl" -- errors
