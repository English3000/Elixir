defmodule MP3 do
  def dir(directory) do
    {:ok, files} = File.ls(directory)
    Enum.filter( files, &(String.ends_with?(&1, ".mp3")) )
    |> Enum.map( &({&1, decode(&1)}) )
    |> Enum.filter(fn {_, :error} -> false
                                _ -> true end)
    |> dump("mp3data")
  end

  def dump(file, term) do
    output = file <> ".tmp" ; IO.inspect(output, label: "dumping to")
    {:ok, pid} = File.open(output, [:write]) ; IO.inspect(pid, term)
    File.close(pid)
  end

  defp decode(file) do
    case File.open(file, [:read, :binary, :raw]) do
      {:ok, pid} -> size = :filelib.file_size(file)
                    result = :file.pread(pid, size - 128, 128) |> parse()
                    File.close(pid)
                    result

    end
  end
  # bitstring docs: https://hexdocs.pm/elixir/Kernel.SpecialForms.html#%3C%3C%3E%3E/1
  defp parse(<<?T,?A,?G, title::30, artist::30, album::30, _year::4, _comment::28, 0::8, track::8, _genre::8>>),
    do: {"ID3v1.1", [track: track, title: trim(title), artist: trim(artist), album: trim(album)]}
  defp parse(<<?T,?A,?G, title::30, artist::30, album::30, _year::4, _comment::30, _genre::8>>),
    do: {"ID3v1.1", [title: trim(title), artist: trim(artist), album: trim(album)]}
  defp parse(_),
    do: :error

  defp trim(binary),
    do: binary
        |> to_string
        |> String.reverse
        |> extract
        |> String.reverse

  defp extract([?\s | tail]), do: extract(tail)
  defp extract([0 | tail]),   do: extract(tail)
  defp extract(string),       do: extract(string)
end
