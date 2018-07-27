defmodule GoogleTest do
  use ExUnit.Case, async: true
  doctest Google

  test "split_string_into_words/2 works" do
    assert Google.split_string_into_words("peanutbutter", ["peanut", "butter"]) == "peanut butter"
    assert Google.split_string_into_words("peanutbutter", []) == ""
  end
end
