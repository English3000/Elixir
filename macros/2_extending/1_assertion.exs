# Implement a refute macro for refutations.
# Run test cases in parallel within Assertion.Test.run/ 2 via spawned processes.
# Add reports for the module. Include pass/ fail counts and execution time.

defmodule Assertion do
  defmacro assert({operator, _, [lhs, rhs]}) do
    quote bind_quoted: [operator: operator, lhs: lhs, rhs: rhs] do
      Assertion.Test.assert(operator, lhs, rhs)
    end
  end

  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
      Module.register_attribute __MODULE__, :tests, accumulate: true
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def run, do: Assertion.Test.run(@tests, __MODULE__)
    end
  end

  defmacro test(title, do: block) do
    function = String.to_atom(title)
    quote do
      @tests {unquote(function), unquote(title)}

      def unquote(function)(), do: unquote(block)
    end
  end
end

defmodule Assertion.Test do
  def run(tests, module) do
    Enum.each tests, fn {function, title} ->
      case apply(module, function, []) do
         :ok            -> IO.write "."
        {:fail, reason} -> IO.puts """
          =================
          FAILURE: #{title}
          =================
          #{reason}
          """
      end
    end
  end

  def assert(:==, lhs, rhs) when lhs == rhs, do: :ok
  def assert(:==, lhs, rhs), do: {:fail, """
    Expected: #{lhs}
    to equal: #{rhs}
    """
  }

  def assert(:>, lhs, rhs) when lhs > rhs, do: :ok
  def assert(:>, lhs, rhs), do: {:fail, """
    Expected:  #{lhs}
    to exceed: #{rhs}
    """
  }
end
