defmodule ChallengesTest do
  use ExUnit.Case, async: true
  doctest Challenges

  defmodule TestIO do
    def gets(_prompt), do: "10"
  end

  describe "Challenges.calc_tip/2" do
    test "works with valid inputs" do
      assert Challenges.calc_tip(10, 15) == [tip: 1.5, sum: 11.5]
    end

    test "rounds up to 2 decimals" do
      assert Challenges.calc_tip(10, 19.25) == [tip: 1.93, sum: 11.93]
    end

    test "handles no inputs" do
      assert Challenges.calc_tip(nil, nil, TestIO) == [tip: 1.0, sum: 11.0]
    end

    test "handles one valid input" do
      assert Challenges.calc_tip(20, nil, TestIO) == [tip: 2.0, sum: 22.0]
    end

    test "handles invalid inputs" do
      assert Challenges.calc_tip(-10, "10", TestIO) == [tip: 1.0, sum: 11.0]
    end
  end
end
