defmodule Assertion do
  defmacro assert({operator, _, [lhs, rhs]}) do
    quote bind_quoted: [operator: operator, lhs: lhs, rhs: rhs] do
      Assertion.Test.assert(operator, lhs, rhs)
    end
  end
end

defmodule Assertion.Test do
  def assert(:==, lhs, rhs) when lhs == rhs, do: IO.write "."
  def assert(:==, lhs, rhs), do: IO.puts """
    FAILURE:
      Expected: #{lhs}
      to equal: #{rhs}
    """

  def assert(:>, lhs, rhs) when lhs > rhs, do: IO.write "."
  def assert(:>, lhs, rhs), do: IO.puts """
    FAILURE:
      Expected:  #{lhs}
      to exceed: #{rhs}
    """
end
