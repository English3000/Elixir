defmodule Erlang do
  @moduledoc """
  Documentation for Erlang syntax: https://elixir-lang.org/crash-course.html

  Elixir
  [3, 2] ++ [1] == [3, 2 | [1]]
  """

  defmodule Lists do
    def map(output, [], _),
      do: output
    def map(output, [head | tail], function),
      do: map(output ++ [function.(head)], tail, function)

    # `for` fn's
      # `:into` https://elixir-lang.org/getting-started/comprehensions.html#the-into-option
    def quicksort([]),
      do: []
    def quicksort([pivot | tail]) do
      quicksort(for item <- tail,
                    item < pivot,
                      do: item) ++

      [pivot] ++

      quicksort(for item <- tail,
                    item >= pivot,
                      do: item)
    end

    def pythagorean_triplets(n),
      do: for a <- 1..n,
              b <- 1..n,
              c <- 1..n,
              a + b + c <= n,
              a*a + b*b == c*c,
                do: {a, b, c}

    def permutations([]),
      do: [[]]
    def permutations(charlist),
      do: for head <- charlist,
              tail <- permutations(charlist -- [head]),
                do: [head | tail]

    def odds_and_evens(list),
      do: odds_and_evens(list, [], [])
    defp odds_and_evens([], odds, evens),
      do: {Enum.reverse(odds), Enum.reverse(evens)}
    defp odds_and_evens([head | tail], odds, evens) do
      case rem(head, 2) do
        1 -> odds_and_evens(tail, [head | odds], evens)
        0 -> odds_and_evens(tail, odds, [head | evens])
      end
    end

    def filter(list, function),
      do: for item <- list,
              function.(item) == true,
                do: item
  end

  defmodule Enums do
    def map(enum, function),
      do: for item <- enum, do: function.(item)
      # erl: [function.(item) || item <- list]
  end

  defmodule Tuples do
    def to_list(tuple),
      do: to_list(tuple, 0, [])
    defp to_list(tuple, index, output) when index < tuple_size(tuple),
      do: to_list(tuple, index + 1, [elem(tuple, index) | output])
    defp to_list(_tuple, _index, output),
      do: Enum.reverse(output)
  end
end
