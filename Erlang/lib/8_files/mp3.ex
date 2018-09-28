defmodule MP3 do
  def dir(directory) do
    {:ok, files} = File.ls(directory)
    Enum.filter( files, &(String.ends_with?(&1, ".mp3")) )
    |> Enum.map( &({&1, decode(&1)}) )
    |> Enum.filter(fn {_, :error} -> false
                                _ -> true end)
    |> dump("mp3data")
  end

  defp decode(file) do
    case File.open(file, [:read, :binary, :raw]) do
      {:ok, pid} -> size = :filelib.file_size(file)
                    result = :file.pread(pid, size - 128, 128) |> parse()
                    File.close(pid)
                    result

    end
  end

  defp parse(<<>>) do
    # L 6576 -- focus on parsing properly
  end

  def dump(file, term) do
    output = file <> ".tmp" ; IO.inspect(output, label: "dumping to")
    {:ok, pid} = File.open(output, [:write]) ; IO.inspect(pid, term)
    File.close(pid)
  end
end
