defmodule Erlang do
  @moduledoc """
  Documentation for Erlang syntax: https://elixir-lang.org/crash-course.html

  Install :dialyxr globally, then `mix dialyzer`

  ### Elixir

  `[3, 2] ++ [1] == [3, 2 | [1]]`

  `__STACKTRACE__` (in `rescue`/`catch` block)

  `for _ <- _, into: _, do: _`

  `@spec` can have guards && multiple clauses

  `@type` == global (vs `@typep`)
  """

  defmodule Lists do
    def map(output, [], _),
      do: output
    def map(output, [head | tail], function),
      do: map(output ++ [function.(head)], tail, function)

    # `for` fn's
    #   `:into` https://elixir-lang.org/getting-started/comprehensions.html#the-into-option
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

    def get_word(binary, number), # incorrect destructuring in Elixir
      do: {_, << c :: size(32), _ :: binary >>} = split_binary(binary, number); c

    def unpack_header(x) do
      decode_header(x)
    catch
      _ -> :error
    end

    def decode_header(<< Integer.parse(11111111111, 2) :: size(11), b :: size(2), c :: 2, _d :: 1,
                         e :: size(4), f :: size(2), g :: size(1), bits :: size(9) >>) do
      vsn = case b do
              0 -> {2,5}
              1 -> exit(:bad_vsn)
              2 -> 2
              3 -> 1
            end

      layer = case c do
                0 -> exit(:bad_layer)
                1 -> 3
                2 -> 2
                3 -> 1
              end
      # functions below aren't def'd
      bit_rate = bit_rate(vsn, layer, e) * 1000
      sample_rate = sample_rate(vsn, f)
      padding = g
      frame_length = frame_length(layer, bit_rate, sample_rate, padding)

      case frame_length < 21 do
         true -> exit(:frame_size)
        false -> {:ok, frame_length, {layer, bit_rate, sample_rate, vsn, bits}}
      end
    end
    # https://hexdocs.pm/elixir/typespecs.html#defining-a-specification
    # can define guards && multiple clauses for specs
    @spec decode_header(arg) :: pid when arg: any, pid: pid
    @spec decode_header(arg :: any) :: pid :: pid
    @spec decode_header(arg :: any) :: pid :: atom
    def decode_header(_),
      do: exit(:bad_header)
    # "Custom types defined through `@type` are exported and available outside the module they’re defined in.
    # If you want to keep a custom type private, you can use the `@typep` directive instead of `@type`."
    # https://elixir-lang.org/getting-started/typespecs-and-behaviours.html#defining-custom-types
  end
end
