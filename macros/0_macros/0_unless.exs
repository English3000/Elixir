defmodule ControlFlow do
  @moduledoc """
  iex(5)> number = 5
  5

  iex(6)> ast = quote do: number * 10
  {:*, [context: Elixir, import: Kernel], [{:number, [], Elixir}, 10]}

  iex(7)> Code.eval_quoted ast
  warning: variable "number" does not exist and is being expanded to "number()",
  please use parentheses to remove the ambiguity or change the variable name nofile:1

  ** (CompileError) nofile:1: undefined function number/0
      (stdlib) lists.erl:1354: :lists.mapfoldl/3
      (elixir) lib/code.ex:493: Code.eval_quoted/3

  iex(7)> ast = quote do: unquote(number) * 10
  {:*, [context: Elixir, import: Kernel], [5, 10]}

  iex(8)> Code.eval_quoted ast
  {50, []}
  """
  defmacro unless(expression, do: block, else: block2) do
    # quote do: if !unquote(expression), do: unquote(block)
    quote do
      case unquote(expression) do
        result when result in [false, nil] -> unquote(block)
                                         _ -> unquote(block2)
      end
    end
  end
end
