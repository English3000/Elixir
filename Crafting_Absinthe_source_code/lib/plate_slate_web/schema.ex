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
  use Absinthe.Relay.Schema, :modern
  alias PlateSlateWeb.Resolvers
  alias PlateSlate.{Menu, Repo}
  import_types PlateSlateWeb.Types.Menu
  import_types PlateSlateWeb.Types.Ordering
  import_types PlateSlateWeb.Types.Accounts
  import_types Absinthe.Phoenix.Types

  def middleware(middleware, field, object) do
    middleware
    |> apply(:errors, field, object)
    |> apply(:get_string, field, object)
    |> apply(:debug, field, object)
  end

  defp apply(middleware, :errors, _field, %{identifier: :mutation}) do
    middleware ++ [PlateSlateWeb.Middleware.ChangesetErrors]
  end
  defp apply([], :get_string, field, %{identifier: :allergy_info}) do
    [{Absinthe.Middleware.MapGet, to_string(field.identifier)}]
  end
  defp apply(middleware, :debug, _field, _object) do
    if System.get_env("DEBUG") do
      [{PlateSlateWeb.Middleware.Debug, :start}] ++ middleware
    else
      middleware
    end
  end
  defp apply(middleware, _,_,_), do: middleware

  def plugins, do: [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults]

  # def middleware(middleware, field, %{identifier: :allergy_info} = object) do
    # expect string key instead of atom
  #   new_middleware = {Absinthe.Middleware.MapGet, to_string(field.identifier)}
  #   middleware |> Absinthe.Schema.replace_default(new_middleware, field, object)
  # end
  # def middleware(middleware, _field, %{identifier: :mutation}) do
  #   middleware ++ [PlateSlateWeb.Middleware.ChangesetErrors]
  # end
  # def middleware(middleware, _field, _object), do: middleware

  def context(ctx), do: Map.put(ctx, :loader, dataloader())
  def dataloader(), do: Dataloader.new |> Dataloader.add_source(Menu, Menu.data())

  node interface do
    resolve_type fn
      %Menu.Item{}, _ -> :menu_item
                  _,_ -> nil
    end
  end

  query do
    # import_fields :menu_queries
    @desc "Gets a list of all available menu items"
    connection field :menu_items, node_type: :menu_item do
      arg :filter, :menu_item_filter #OR, #non_null(:menu_item_filter)
      arg :order, type: :sort_order, default_value: :asc
      resolve &Resolvers.Menu.menu_items/3
    end

    field :menu_item, :menu_item do
      arg :id, non_null(:id)
      resolve &Resolvers.Menu.get_item/3
    end

    # import_fields :search_queries
    field :search, list_of(:search_result) do
      arg :match, non_null(:string)
      resolve &Resolvers.Menu.search/3
    end

    field :me, :user do
      middleware PlateSlateWeb.Middleware.Authorize, :any
      resolve &Resolvers.Accounts.me/3
    end

    node field do
      resolve fn
        %{type: :menu_item, id: local_id}, _ -> {:ok, Repo.get(Menu.Item, local_id)}
                                         _,_ -> {:error, "Unknown node"}
      end
    end
  end

  mutation do
    # import_fields :menu_inputs
    field :create_menu_item, :menu_item_result do
      arg :input, non_null(:menu_item_input)
      middleware PlateSlateWeb.Middleware.Authorize, "employee"
      resolve &Resolvers.Menu.create_item/3
      # middleware Middleware.ChangesetErrors
    end

    # import_fields :ordering_inputs
    field :place_order, :order_result do
      arg :input, non_null(:place_order_input)
      middleware PlateSlateWeb.Middleware.Authorize, :any
      resolve &Resolvers.Ordering.place_order/3
    end

    field :ready_order, :order_result do
      arg :id, non_null(:id)
      resolve &Resolvers.Ordering.ready_order/3
    end

    field :complete_order, :order_result do
      arg :id, non_null(:id)
      resolve &Resolvers.Ordering.complete_order/3
    end

    # import_fields :accounts_inputs
    field :sign_in, :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      arg :role, non_null(:role)
      resolve &Resolvers.Accounts.sign_in/3
      middleware fn resolution, _ ->
        with %{value: %{user: user}} <- resolution do
          %{resolution | context: Map.put(resolution.context, :current_user, user)}
        end
      end
    end
  end

  object :input_error do
    field :key, non_null(:string)
    field :message, non_null(:string)
  end

  subscription do
    field :new_order, :order do
      config fn _args, %{context: context} ->
        case context[:current_user] do
          %{role: "customer", id: id} -> {:ok, topic: id}
          %{role: "employee"}         -> {:ok, topic: "*"}
                                    _ -> {:error, "unauthorized"}
        end
      end
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

    field :new_menu_item, :menu_item do
      config fn _args, _info -> {:ok, topic: "*"} end
    end
  end

  scalar :date do
    parse fn input ->
      with %Absinthe.Blueprint.Input.String{value: value} <- input,
             {:ok, date} <- Date.from_iso8601(value) do {:ok, date}
      else
        _ -> :error
      end
    end

    serialize fn date -> Date.to_iso8601(date) end #converts to "YY-MM-DD"
  end

  scalar :decimal do
    parse fn
      %{value: value}, _ -> Decimal.parse(value)
                     _,_ -> :error
    end

    serialize &to_string/1
  end
end
