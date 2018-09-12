defmodule ErlangTest do
  use ExUnit.Case
  doctest Erlang

  test "pythagorean_triplets" do
    assert Erlang.Lists.pythagorean_triplets(16) == [{3,4,5}, {4,3,5}]
    assert Erlang.Lists.pythagorean_triplets(30) == [ {3,4,5},  {4,3,5},  {5,12,13},
                                                      {6,8,10}, {8,6,10}, {12,5,13} ]
  end

  test "permutations" do
    assert Erlang.Lists.permutations('123') == [ '123', '132', '213',
                                                 '231', '312', '321' ]
  end
end
