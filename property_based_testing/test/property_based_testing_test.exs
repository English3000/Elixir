defmodule PropertyBasedTestingTest do
  use ExUnit.Case
  use PropCheck # types from here, NOT Elixir

  defp is_ordered([first, second | tail]),
    do: first <= second and is_ordered([second | tail])
  defp is_ordered([_head | []]), do: true
  # defp is_ordered([]),           do: true

  describe ": List.sort/1\n" do
    property "\t* a sorted list has ordered pairs" do
      forall list <- non_empty(list(any)),
        do: list
            |> Enum.sort
            |> is_ordered()
    end

    property "\t * input and output have same length" do
      #
    end
  end

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
        do: List.last(list ++ [last]) == last
    end
  end

   ...But then you're relying on `++/2`

   Testing is ultimately a question of
   which parts of the system you just trust to be correct,

   ~ Ch. 3, "Property-Based Testing with PropEr, Erlang, and Elixir" by Fred Hebert
  """
  defp model_biggest(n),
    do: n |> Enum.sort |> List.last

  describe "~ biggest/2" do
    property "finds biggest element" do
      forall n <- non_empty(list(integer)),
        do: PropertyBasedTesting.biggest(n) == model_biggest(n)
    end
  end
end
