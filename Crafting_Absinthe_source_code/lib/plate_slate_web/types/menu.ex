defmodule PlateSlateWeb.Types.Menu do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers
  alias PlateSlateWeb.{Middleware, Resolvers}
  alias PlateSlate.Menu
  alias PlateSlate.Menu.{Item, Category}

  # object :menu_queries do
  #   @desc "Gets a list of all available menu items"
  #   field :menu_items, list_of(:menu_item) do
  #     arg :filter, :menu_item_filter #OR, #non_null(:menu_item_filter)
  #     arg :order, type: :sort_order, default_value: :asc
  #     resolve &Resolvers.Menu.menu_items/3
  #   end
  # end

  # object :search_queries do
  #   field :search, list_of(:search_result) do
  #     arg :match, non_null(:string)
  #     resolve &Resolvers.Menu.search/3
  #   end
  # end

  # object :menu_inputs do
  #   field :create_menu_item, :menu_item_result do #imported--returns a :menu_item
  #     arg :input, non_null(:menu_item_input)
  #     middleware Middleware.Authorize, "employee"
  #     resolve &Resolvers.Menu.create_item/3
  #     # middleware Middleware.ChangesetErrors
  #   end
  # end

  object :menu_item do
    interfaces [:search_result]
    field :id, :id
    field :name, :string
    field :description, :string
    field :price, :decimal #apparently globally accessible once defined
    field :added_on, :date
    field :allergy_info, list_of(:allergy_info)
    field :category, :category do
      resolve dataloader(Menu)
      # resolve dataloader(Item, :category)
      # resolve &Resolvers.Menu.item_categories/3
    end
    field :order_history, :order_history do
      arg :since, :date
      middleware Middleware.Authorize, "employee"
      resolve &Resolvers.Ordering.order_history/3
    end
  end

  object :allergy_info do
    field :allergen, :string #do
      #resolve fn parent, _,_ -> {:ok, Map.get(parent, "allergen")}
    #end
    field :severity, :string #do
      #resolve fn parent, _,_ -> {:ok, Map.get(parent, "severity")}
    #end
  end

  object :category do
    interfaces [:search_result]
    field :name, :string
    field :description, :string
    field :items, list_of(:menu_item) do
      arg :filter, :menu_item_filter
      arg :order, type: :sort_order, default_value: :asc
      resolve dataloader(Menu, :items)
      # resolve &Resolvers.Menu.category_items/3
    end
  end

  object :order_history do
    field :orders, list_of(:order), do: resolve &Resolvers.Ordering.orders/3
    field :quantity, non_null(:integer), do: resolve Resolvers.Ordering.stat(:quantity)
    @desc "Gross Revenue"
    field :gross, non_null(:float), do: resolve Resolvers.Ordering.stat(:gross)
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


  interface :search_result do
    field :name, :string
    resolve_type fn
          %Item{}, _ -> :menu_item
      %Category{}, _ -> :category
                 _,_ -> nil
    end
  end


  object :menu_item_result do
    field :menu_item, :menu_item
    field :errors, list_of(:input_error) #handling errors as data
  end

  input_object :menu_item_input do
    field :name, non_null(:string)
    field :description, :string
    field :price, non_null(:decimal) #enforces 2 digits after dot
    field :category_id, non_null(:id)
  end
end
