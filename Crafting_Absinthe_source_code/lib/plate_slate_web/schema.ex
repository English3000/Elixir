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
  import_types __MODULE__.OrderingTypes
  import_types __MODULE__.AccountsTypes

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

  def middleware(middleware, field, %{identifier: :allergy_info} = object) do
    # expect string key instead of atom
    new_middleware = {Absinthe.Middleware.MapGet, to_string(field.identifier)}
    middleware |> Absinthe.Schema.replace_default(new_middleware, field, object)
  end
  def middleware(middleware, _field, %{identifier: :mutation}) do
    middleware ++ [PlateSlateWeb.Schema.Middleware.ChangesetErrors]
  end
  def middleware(middleware, _field, _object), do: middleware

  query do
    import_fields :menu_queries
    import_fields :search_queries
  end

  mutation do
    import_fields :menu_inputs #works!
    import_fields :ordering_inputs
    import_fields :accounts_inputs
  end

  subscription do
    field :new_order, :order do
      config fn _args, _info -> {:ok, topic: "*"} end
      # resolve fn root, _,_ -> IO.inspect(root); {:ok, root} end
    end

    field :update_order, :order do
      arg :id, non_null(:id)
      config fn args, _info -> {:ok, topic: args.id} end
      trigger [:ready_order, :complete_order], topic: fn
        %{order: order} -> [order.id]
        # don't push to anything if error (b/c then order wasn't updated)
                      _ -> []
      end
      resolve fn %{order: order}, _,_ -> {:ok, order} end
    end
  end
end
