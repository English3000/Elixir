defmodule PropertyBasedTesting do
  def biggest([head | tail]), do: biggest(tail, head)

  defp biggest([], max),                             do: max
  defp biggest([head | tail], max) when head > max,  do: biggest(tail, head)
  defp biggest([head | tail], max) when head <= max, do: biggest(tail, max)

  def encode(data), do: :erlang.term_to_binary(data)
  def decode(data), do: :erlang.binary_to_term(data)
end
