defmodule OutcoTest do
  use ExUnit.Case
  doctest Outco

  test "valid_palindrome/1 works" do
    assert Outco.valid_palindrome("racecar")
    assert Outco.valid_palindrome("raceucar")
    refute Outco.valid_palindrome("raceuccar")
    assert Outco.valid_palindrome("aabba")
    assert Outco.valid_palindrome("abbaa")
    refute Outco.valid_palindrome("abcab")
  end
end
