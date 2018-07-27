defmodule IOTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO
  import Challenges.IO
  doctest Challenges.IO

  defmodule TestIO do
    def gets(_prompt), do: "Tester"
  end


  @greet "Hello, "
    @ing "! Nice to meet you\n"

  describe "greeting/2" do
    test "prints greeting" do
      assert capture_io(fn -> greeting("User") end) ==
        @greet <> "User" <> @ing
      assert capture_io(fn -> greeting(nil, TestIO) end) ==
        @greet <> "Tester" <> @ing
    end
  end

  describe "string_stats/2" do
    test "shows correct stats" do
      assert capture_io(fn -> string_stats("test") end) ==
        "test is 4 characters long and contains 3 characters.\n"
    end
  end

  describe "mad_lib/5" do
    test "correctly handles inputs" do
      assert capture_io(fn ->
        mad_lib(nil, "test", "testy", "testingly", TestIO)
      end) == "Do you test your testy Tester testingly?\n"
    end
  end
end
