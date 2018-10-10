defmodule OtpTest do
  use ExUnit.Case
  doctest Otp

  test "greets the world" do
    assert Otp.hello() == :world
  end
end
