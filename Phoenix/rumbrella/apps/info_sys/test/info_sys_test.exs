defmodule InfoSysTest do
  use ExUnit.Case
  doctest InfoSys

  test "greets the world" do
    assert InfoSys.hello() == :world
  end
end
