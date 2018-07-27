defmodule Mime do
  @moduledoc """
  Reads "mimes.txt" by line and for each
  splits the MIME type & file extensions and defines a pair of conversion functions.
  """
  @external_resource mimes_path = Path.join([__DIR__, "mimes.txt"])

  for line <- mimes_path |> Path.join |> File.stream! do
    [type, rest] = line |> String.split("\t")
                        |> Enum.map(&String.strip(&1))

    exts = String.split(rest, ~r/,\s?/)

    @doc "Generates function, mapping MIME type to file extension."
    def exts_from_type(unquote(type)), do: unquote(exts)
    @doc "Generate function, mapping file extension to MIME type."
    def type_from_ext(ext) when ext in unquote(exts), do: unquote(type)
    # def unquote(name)()...
  end

  def exts_from_type(_type), do: []
  def type_from_ext(_ext), do: nil

  def valid_type?(type), do: exts_from_type(type) |> Enum.any?
end
