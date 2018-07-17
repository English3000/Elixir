defmodule DataStructures.CoordinateTest do
  use ExUnit.Case, async: true
  use ExUnitProperties # "module ExUnitProperties is not loaded and could not be found"
  alias IslandsEngine.DataStructures

  IO.puts "Coordinate.new/3"

  property "given valid range, handles row & col inputs properly" do
    check all        first <- integer(1..5),
                      last <- integer(6..10),
                  in_range <- integer(1..5),
                   non_int <- integer(-4..0),
              not_in_range <- integer(11..15) do
      assert {:ok, _}    = DataStructures.Coordinate.new(in_range, in_range, first..last)
      assert {:error, _} = DataStructures.Coordinate.new(non_int, in_range, first..last)
      assert {:error, _} = DataStructures.Coordinate.new(in_range, not_in_range, first..last)
    end
  end
end
