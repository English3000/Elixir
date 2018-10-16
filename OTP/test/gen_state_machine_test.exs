defmodule GenStateMachineTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO
  alias OTP.Coffee.GenStateMachine
  # https://github.com/English3000/Elixir/blob/master/practice/57challenges/test/io_test.exs
  describe "OTP.Coffee.GenStateMachine" do
    test "start_link/0" do
      assert capture_io(&GenStateMachine.start_link/0) == """
      Machine: Rebooted hardware
      Display: Make your selection
      """
    end

    test "cancel purchase" do
      {:ok, pid} = GenStateMachine.start_link()
      # can't capture b/c another function does logging
      assert capture_io(&GenStateMachine.tea/0) == """
      Display: Please pay 100
      """

      assert capture_io(&GenStateMachine.cancel/0) == """
      Machine: Returned 0 in change
      Display: Make your selection
      """
    end
  end
end
