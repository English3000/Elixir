defmodule MathTest do
  import Assertion
  def run do
    assert 5 == 5
    assert 10 > 0
    assert 10 * 10 == 99
    assert 1 > 2
  end
end
