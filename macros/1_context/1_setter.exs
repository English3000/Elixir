defmodule Setter do
  defmacro bind_name(string) do
    quote do: var!(name) = unquote(string)
  end
end
