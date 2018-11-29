defmodule PropertyBasedTestingTest do
  use ExUnit.Case
  use PropCheck # types from here, NOT Elixir

  import PropertyBasedTesting

  @moduledoc ~S"""
  Types of Tests
  : invariant
  ~ model

  Modeling means writing an indirect implementation of your code—
  often an algorithmically inefficient one—
  and testing the real one against it.

  The model should be so simple it is obviously correct.

  # Property Example

  describe "List.last/1" do
    property "returns the last value" do
      forall {list, last} <- { list(any()), any() },
        do: last == list
                    |> fn list -> list ++ [last] end .()
                    |> List.last()
    end
  end

  ...But then you're relying on `++/2`

  Testing is ultimately a question of
  which parts of the system you just trust to be correct,

  # Invariants Example

  defp is_ordered(list) when length(list) < 2, do: true
  defp is_ordered([head | tail]), do: head <= List.first(tail) and is_ordered(tail)

  describe ": List.sort/1\n" do
    property "\t* ascending elements" do
      forall list <- list(any),
        do: list
            |> Enum.sort
            |> is_ordered()
    end

    property "\t * length unchanged" do
      forall list <- list(any),
        do: length(list) == list
                            |> Enum.sort
                            |> length()
    end

    property "\t * elements unchanged" do
      forall list <- list(any),
        do: list
            |> Enum.sort
            |> Enum.all?(& &1 in list)
    end
  end

  ~ Ch. 3, "Property-Based Testing with PropEr, Erlang, and Elixir" by Fred Hebert
  """
  defp model_biggest(n),
    do: n |> Enum.sort |> List.last

  describe "~ biggest/2" do
    property "finds biggest element" do
      forall n <- non_empty(list(integer)),
        do: biggest(n) == model_biggest(n)
    end
  end

  describe "encode/1 + decode/1" do
    property "symmetry test" do
      forall list <- list({atom, any}) do
        encoded = encode(list)

        is_binary(encoded) and list == decode(encoded)
      end
    end
  end

  # `mix test --only exercise`
  # `mix test help`
  @tag exercise: :Ch_3
  describe "~ MapSet.union/2" do
    property "works" do
      forall {list1, list2} <- {list(any), list(any)} do
        list1 ++ list2 |> Enum.uniq |> Enum.sort()
          ==
        MapSet.union( MapSet.new(list1), MapSet.new(list2) ) |> MapSet.to_list |> Enum.sort()
      end
    end
  end

  defp extract_keys(list), do: (for {k, _} <- list, do: k)

  @tag exercise: :Ch_3
  describe "~ Map.merge/3" do # doesn't test the function?? doesn't test multiple layers?? # No, only validates keys.
    property "has good coverage" do
      forall {list1, list2} <- {list({any, any}), list({any, any})} do
        Map.merge( Map.new(list1), Map.new(list2), fn _k, v1, _v2 -> v1 end)
        |> Map.to_list
        |> Enum.sort
        |> extract_keys()
          ==
        list1 ++ list2
        |> extract_keys
        |> Enum.uniq
        |> Enum.sort()
      end
    end
  end

  # TODO: Move to second test module. @ L 2548
  describe "collect/2" do
    defp to_range(b, a) do
      low = div(b, a) * a

      {low, low + a}
    end

    property "example", [:verbose] do
      forall string <- binary do
        #        test               metric
        collect( is_binary(string), string |> byte_size |> to_range(10) )
      end
    end

    defp key, do: oneof([range(1, 10), integer])

    property "get map keys, incl. duplicates", [:verbose] do
      forall kv <- list({key, any}) do
        map = Map.new(kv)
        for {key, _} <- kv, do: Map.fetch!(map, key)

        collect(true, {:duplicates, length(kv) -
        (List.keysort(kv, 0)
        |> Enum.dedup_by(&elem(&1, 0))
        |> length)
        |> to_range(5) })
      end
    end
  end

  describe "aggregate/2" do
    @suits [:club, :diamond, :heart, :spade]
    property "example", [:verbose] do
      forall hand <- vector(5, { oneof(@suits), choose(1, 13) }),
        do: aggregate(true, hand)
    end

    defp escape(_), do: true

    defp classes(""), do: []
    defp classes(string) do
      %{true => letters,     false => rest}  = string
                                               |> String.to_charlist
                                               |> Enum.group_by(&letter?/1)

      %{true => numbers,     false => rest}  = Enum.group_by(rest, &number?/1)
      %{true => punctuation, false => other} = Enum.group_by(rest, &punctuation?/1)

      [ letters:     stats(letters),
        numbers:     stats(numbers),
        punctuation: stats(punctuation),
        other:       stats(other) ]
    end

    defp letter?(char),
      do: (?a <= char and char <= ?z) or
          (?A <= char and char <= ?Z)

    defp number?(char), do: ?0 <= char and char <= ?9

    defp punctuation?(char), do: char in '.,;:\'"-'

    defp stats(charlist), do: charlist |> length |> to_range(5)

    property "fake escaping test" do
      forall string <- utf8 do
        try do
          aggregate(escape(string), classes(string))
        rescue
          value -> IO.inspect(value)
        end
      end
    end
  end
end
