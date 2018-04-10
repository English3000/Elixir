#---
# Excerpted from "Craft GraphQL APIs in Elixir with Absinthe",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/wwgraphql for more book information.
#---
defmodule PlateSlateWeb.Schema do
  use Absinthe.Schema
  import_types __MODULE__.MenuTypes

  scalar :date do
    parse fn input ->
      with %Absinthe.Blueprint.Input.String{value: value} <- input,
             {:ok, date} <- Date.from_iso8601(value) do {:ok, date}
      else
        _ -> :error
      end
    end

    serialize fn date ->
      Date.to_iso8601(date) #converts to "YY-MM-DD"
    end
  end

  scalar :decimal do
    parse fn
      %{value: value}, _ -> Decimal.parse(value)
                     _,_ -> :error
    end

    serialize &to_string/1
  end

  query do
    import_fields :menu_queries
    import_fields :search_queries
  end

  mutation do
    import_fields :menu_inputs #works!
  end
end
