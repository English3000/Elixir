defmodule Math do
  @moduledoc """
  Destructured AST operations for :+ and :*
  to add printing functionality.

  To see the AST for an operation, in iex,
  `quote do:` operation
  """
  defmacro say({:+, _, [lhs, rhs]}) do
    quote do
      lhs = unquote(lhs)
      rhs = unquote(rhs)
      result = lhs + rhs
      IO.puts "#{lhs} plus #{rhs} equals #{result}"
      result
    end
  end

  defmacro say({:*, _, [lhs, rhs]}) do
    quote do
      lhs = unquote(lhs)
      rhs = unquote(rhs)
      result = lhs * rhs
      IO.puts "#{lhs} times #{rhs} equals #{result}"
      result
    end
  end
end
