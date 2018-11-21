defmodule PropertyBasedTestingTest do
  use ExUnit.Case
  use PropCheck # types from here, NOT Elixir

  # NOTE: Run `MIX_ENV=test mix propcheck.clean` if generator becomes buggy

  def boolean(_), do: true

  property "works" do
    forall type <- term() do
      boolean(type)
    end
  end

  property "finds biggest element" do
    forall n <- non_empty(list(integer())) do
      PropertyBasedTesting.biggest(n) == n
                                         |> Enum.sort
                                         |> List.last()
    end
  end
end
