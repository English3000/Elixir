defmodule MathTest do
  use Assertion

  test "success cases" do
    assert 5 == 5
    assert 10 > 0
  end

  test "fail cases" do
    assert 10 * 10 == 99
    assert 1 > 2
  end
end
