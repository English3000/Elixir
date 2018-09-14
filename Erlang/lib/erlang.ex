defmodule Erlang do
  @moduledoc """
  Documentation for Erlang syntax: https://elixir-lang.org/crash-course.html

  ### Elixir

  `[3, 2] ++ [1] == [3, 2 | [1]]`

  `__STACKTRACE__` (in `rescue`/`catch` block)
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

  defmodule Maps do
    @moduledoc """
    A map is an ordered collection (hash array mapped trie) of key-value pairs.
    > ARTICLE: https://en.wikipedia.org/wiki/Hash_array_mapped_trie
    > DIAGRAMS: https://www.google.com/search?client=firefox-b-1-ab&ei=1vOaW9vNCJHN8APdwo2oCA&q=erlang+immutable+hash+array+mapped+trie&oq=erlang+immutable+hash+array+mapped+trie&gs_l=psy-ab.3..33i160.13313.16611..16999...0.0..0.156.1267.12j3......0....1..gws-wiz.......0i71j35i39j33i21.-a1izXmP2u0

    Updating a value is space-efficient. Accessing a value is time-efficient.
    > SOURCE: "Programming Erlang", 2nd Ed.

    Adding a new key isn't. Converting a list of N key-value pairs
    (with `:maps.from_list/1`) can be faster than N `Map.put/3` calls.
    > SOURCE: https://groups.google.com/forum/#!topic/elixir-lang-talk/e8GhTYld8as
    """
  end

  defmodule Binaries do
    @doc "Checks 3 MPEG frame headers to identify a proper start location."
    def find_mpeg_header(binary, number),
      do: is_header(binary, number, 3)

    def is_header(binary, number, frame) do
      with {:ok, length, _} <- get_word(binary, number) |> unpack_header(),
                          0 <- frame do
        {:ok, number - length}
      else
        :error -> added = (3 - frame) * length
                  find_mpeg_header(binary, number - added + 1, 3)
             _ -> is_header(binary, number + length, frame - 1)
      end
    end

    def get_word(binary, number),
      do: {_, << c :: size(32), _ :: binary >>} = split_binary(binary, number); c

    def unpack_header(x) do
      decode_header(x)
    catch
      _ -> :error
    end

    def decode_header(<< 2 11111111111 :: size(11), b :: size(2), c :: 2, _d :: 1,
                         e :: size(4), f :: size(2), g :: size(1), bits :: size(9) >>) do
      vsn = case b do
              0 -> {2,5}
              1 -> exit(:badVsn)
              2 -> 2
              3 -> 1
            end

      # resume @ Location 2950
    end
  end
end
