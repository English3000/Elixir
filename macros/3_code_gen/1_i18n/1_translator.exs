defmodule Translator do
  @moduledoc """
  SUMMARIZE WHAT CODE DOES!
  """
  defmacro __using__(_options) do
    quote do
      Module.register_attribute __MODULE__, :locales, accumulate: true

      import unquote(__MODULE__), only: [locale: 2]

      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(env) do
    Module.get_attribute(env.module, :locales)
    |> compile
  end

  def compile(translations) do
    ast = for {locale, mappings} <- translations,
      do: deftranslations(locale, "", mappings)

    final = quote do
      def t(locale, path, bindings \\ [])
      unquote(ast)
      def t(_locale, _path, _bindings), do: {:error, :no_translation}
    end

    IO.puts Macro.to_string(final); final
  end

  defp deftranslations(locale, current_path, mappings) do
    for {key, value} <- mappings do
      path = append_path(current_path, key)

      case Keyword.keyword?(value) do # checks for nested keyword list
         true -> deftranslations(locale, path, value)
        false -> quote do
                   def t(unquote(locale), unquote(path), bindings),
                     do: unquote(interpolate(value))
                 end
      end
    end
  end

  @doc "Returns string-interpolated AST for `t/3` function definitions."
  defp interpolate(string) do # @ Location 2149
    ~r/(?<head>)%{[^}]+}(?<tail>)/
    |> Regex.split(string, on: [:head, :tail]) # excludes <head> & <tail> from return value
    |> Enum.reduce("", fn # destructures variables in %{} & replaces them with function inputs
      <<"%{" <> rest>>, acc -> # <> can be used for pattern matching
        key = String.trim_trailing(rest, "}") |> String.to_atom
        quote do: unquote(acc) <> to_string(Keyword.fetch!(bindings, unquote(key)))
      segment, acc -> quote do: (unquote(acc) <> unquote(segment))
    end)
  end

  defp append_path("", next), do: to_string(next)
  defp append_path(current, next), do: "#{current}.#{next}"

  @doc """
  Registers a locale name and list of translations
  to be used by `compile/1` in our `__before_compile__` hook.
  """
  defmacro locale(name, mappings) do
    quote bind_quoted: [name: name, mappings: mappings] do
      @locales {name, mappings}
    end
  end
end
