defmodule DataStructures.CoordinateTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  alias IslandsEngine.DataStructures.Coordinate

  IO.puts "Coordinate.new/3"
  property "given valid range, handles row & col inputs properly" do
    check all        first <- integer(1..5),
                      last <- integer(6..10),
                  in_range <- integer(first..last),
                   non_int <- integer(first * -1..0),
              not_in_range <- integer(last + 1..last * 2) do
      assert {:ok, _}    = Coordinate.new(in_range, in_range, first..last)
      assert {:error, _} = Coordinate.new(non_int, in_range, first..last)
      assert {:error, _} = Coordinate.new(in_range, not_in_range, first..last)
    end
  end
end
