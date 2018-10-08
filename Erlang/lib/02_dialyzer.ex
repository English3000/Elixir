defmodule Dialyzer do
  def test1,
    do: :erlang.time() |> seconds()

  def seconds({_year, _month, _day, hour, min, sec}),
    do: (hour * 60 + min) * 60 + sec

  def test2,
    do: List.to_tuple({:a, :b, :c}) |> tuple_size()

  def test3,
    do: factorial(-5)

  defp factorial(0),
    do: 1
  defp factorial(n),
    do: n * factorial(n - 1)
end
