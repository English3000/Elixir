defmodule PlateSlateWeb.Schema.MenuTypes do
  use Absinthe.Schema.Notation
  alias PlateSlateWeb.Resolvers
  alias PlateSlate.Menu.{Item, Category}

  object :menu_item do
    interfaces [:search_result]
    field :id, :id
    field :name, :string
    field :description, :string
    field :added_on, :date
  end

  @desc "Filter query by..."
  input_object :menu_item_filter do
    field :name, :string
    field :category, :string #OR, #non_null(:string)
    field :tag, :string
    field :priced_above, :float
    field :priced_below, :float
    field :added_before, :date
    field :added_after, :date
  end

  enum :sort_order do
    value :asc
    value :desc
  end

  object :menu_queries do
    @desc "Gets a list of all available menu items"
    field :menu_items, list_of(:menu_item) do
      arg :filter, :menu_item_filter #OR, #non_null(:menu_item_filter)
      arg :order, type: :sort_order, default_value: :asc
      resolve &Resolvers.Menu.menu_items/3
    end
  end

  object :category do
    interfaces [:search_result]
    field :name, :string
    field :description, :string
    field :items, list_of(:string) do
      resolve &Resolvers.Menu.items_for_category/3
    end
  end

  interface :search_result do
    field :name, :string
    resolve_type fn
          %Item{}, _ -> :menu_item
      %Category{}, _ -> :category
                 _,_ -> nil
    end
  end

  object :search_queries do
    field :search, list_of(:search_result) do
      arg :match, non_null(:string)
      resolve &Resolvers.Menu.search/3
    end
  end
end
