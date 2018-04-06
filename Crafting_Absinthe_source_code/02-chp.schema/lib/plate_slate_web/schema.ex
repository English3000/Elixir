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

  enum :sort_order do
    value :asc
    value :desc
  end

  object :menu_item do
    field :id, :id
    field :name, :string
    field :description, :string
  end

  @desc "Filter query by..."
  input_object :menu_item_filter do
    field :name, :string
    field :category, :string
    field :tag, :string
    field :priced_above, :float
    field :priced_below, :float
  end

  query do
    @desc "Gets a list of all available menu items"
    field :menu_items, list_of(:menu_item) do
      arg :filter, :menu_item_filter
      arg :order, type: :sort_order, default_value: :asc
      resolve &Resolvers.Menu.menu_items/3
    end
  end
end
