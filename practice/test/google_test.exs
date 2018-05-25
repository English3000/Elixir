defmodule GoogleTest do
  use ExUnit.Case
  doctest Google

  test "" do
    assert Google.hello() == :world
  end
end
