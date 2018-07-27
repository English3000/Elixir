defmodule Loop do
  defmacro while(expression, do: block) do
    quote do
      try do
        for _ <- Stream.cycle([:ok]) do
          case unquote(expression) do
            result when result in [false, nil] -> throw :break
                                             _ -> unquote(block)
          end
        end
      catch
        :break -> :ok
      end
    end
  end
end
