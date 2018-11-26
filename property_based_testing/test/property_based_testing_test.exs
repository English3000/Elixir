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
end
