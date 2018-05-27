defmodule PracticeTest do
  use ExUnit.Case, async: true
  doctest Practice

  test "map/2" do
    assert Practice.map([1,2,3], &(&1 * 2)) == [2,4,6]
  end
end
