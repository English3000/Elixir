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

  alias PlateSlateWeb.Resolvers
  alias PlateSlateWeb.Schema.Middleware

  def middleware(middleware, _field, %{identifier: :mutation}) do
    middleware ++ [Middleware.ChangesetErrors]
  end
  def middleware(middleware, _field, _object) do
    middleware
  end

  import_types __MODULE__.MenuTypes
  import_types __MODULE__.OrderingTypes

  query do
    # Other query fields


    field :menu_items, list_of(:menu_item) do
      arg :filter, :menu_item_filter
      arg :order, type: :sort_order, default_value: :asc
      resolve &Resolvers.Menu.menu_items/3
    end

    field :search, list_of(:search_result) do
      arg :matching, non_null(:string)
      resolve &Resolvers.Menu.search/3
    end

  end

  # Other schema content
  mutation do
    # Other mutation fields

    field :ready_order, :order_result do
      arg :id, non_null(:id)
      resolve &Resolvers.Ordering.ready_order/3
    end
    field :complete_order, :order_result do
      arg :id, non_null(:id)
      resolve &Resolvers.Ordering.complete_order/3
    end

    field :place_order, :order_result do
      arg :input, non_null(:place_order_input)
      resolve &Resolvers.Ordering.place_order/3
    end

    field :create_menu_item, :menu_item_result do
      arg :input, non_null(:menu_item_input)
      resolve &Resolvers.Menu.create_item/3
    end

  end

  subscription do
    field :update_order, :order do
      arg :id, non_null(:id)

      config fn args, _info ->
        {:ok, topic: args.id}
      end

      trigger [:ready_order, :complete_order], topic: fn
        %{order: order} -> [order.id]
        _ -> []
      end

      resolve fn %{order: order}, _ , _ ->
        {:ok, order}
      end
    end

    # Other fields

    field :new_order, :order do
      config fn _args, _info ->
        {:ok, topic: "*"}
      end
    end
  end

  @desc "An error encountered trying to persist input"
  object :input_error do
    field :key, non_null(:string)
    field :message, non_null(:string)
  end

  scalar :date do
    parse fn input ->
      with %Absinthe.Blueprint.Input.String{value: value} <- input,
      {:ok, date} <- Date.from_iso8601(value) do
        {:ok, date}
      else
        _ -> :error
      end
    end

    serialize fn date ->
      Date.to_iso8601(date)
    end
  end

  scalar :decimal do
    parse fn
      %{value: value}, _ ->
        Decimal.parse(value)
      _, _ ->
        :error
    end
    serialize &to_string/1
  end

  enum :sort_order do
    value :asc
    value :desc
  end


end
