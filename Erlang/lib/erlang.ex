defmodule Erlang do
  @moduledoc """
  Documentation for Erlang syntax: https://elixir-lang.org/crash-course.html

  Elixir
  [3, 2] ++ [1] == [3, 2 | [1]]
  """

  defmodule List do
    def map(output, [], _),
      do: output
    def map(output, [head | tail], function),
      do: map(output ++ [function.(head)], tail, function)

  end

  defmodule Enum do
    def map(enum, function),
      do: for item <- enum, do: function.(item)
      # erl: [function.(item) || item <- list]

    def quicksort([]),
      do: []
    def quicksort([nil | tail]),
      do: tail
    def quicksort([pivot | tail]) do
      quicksort(for item <- tail, do:
                  if item < pivot, do: item) ++

      [pivot] ++

      quicksort(for item <- tail, do:
                  if item >= pivot, do: item)

      |> Enum.reject(&(&1 == nil))
    end
  end
end
