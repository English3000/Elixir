# {:ok, pid} = File.open "lib/8_files/ex.dat", [:read]
#
# defmodule Helper do
#   def print_by_line(pid) do
#     case IO.binread(pid, :line) do
#       :eof -> :eof
#       line -> IO.inspect(line)
#               print_by_line(pid)
#     end
#   end
# end
#
# Helper.print_by_line(pid)
#
# File.close "lib/8_files/ex.dat"

# list = :code.which(:file) |> to_string |> Path.split
# path = Enum.take(list, length(list)-2) |> Path.join()
# :file.consult "/../../.." <> path <> "/src/file.erl" -- errors
