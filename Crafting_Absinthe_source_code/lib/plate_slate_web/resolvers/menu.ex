defmodule PlateSlateWeb.Resolvers.Menu do
  alias PlateSlate.{Menu, Repo}
  import Absinthe.Resolution.Helpers, only: [on_load: 2]

  def menu_items(_, args, _) do
    {:ok, Menu.list_items(args)}
  end

  # def category_items(category, args, %{context: %{loader: loader}}) do
  #   loader |> Dataloader.load(Menu, {:items, args}, category)
  #     |> on_load(fn loader ->
  #                  items = Dataloader.get(loader, Menu, {:items, args}, category)
  #                  {:ok, items}
  #                end)
    # query = Ecto.assoc(category, :items)
    # {:ok, Repo.all(query)} # n+1 query (per category)
  # end

  # def item_categories(menu_item, _, %{context: %{loader: loader}}) do
  #   loader |> Dataloader.load(Menu, :category, menu_item)
  #     |> on_load(fn loader ->
  #                  category = Dataloader.get(loader, Menu, :category, menu_item)
  #                  {:ok, category}
  #                end)

    # batch({Menu, :categories_by_id}, menu_item.category_id,
    #   fn categs -> {:ok, Map.get(categs, menu_item.category_id)} end)
    # |> IO.inspect

    # async(fn ->
    #   query = Ecto.assoc(menu_item, :category)
    #   {:ok, Repo.one(query)}
    # end) |> IO.inspect
  # end

  def search(_, %{match: term}, _) do
    {:ok, Menu.search(term)}
  end

  def get_item(_, %{id: id}, %{context: %{loader: loader}}) do
    loader |> Dataloader.load(Menu, Menu.Item, id)
           |> on_load(fn loader -> {:ok, Dataloader.get(loader, Menu, Menu.Item, id)} end)
  end

  def create_item(_, %{input: params}, _) do
    # case context do
    #   %{current_user: %{role: "employee"}} ->

    # handle cases via middleware
    with {:ok, item} <- Menu.create_item(params) do
      {:ok, %{menu_item: item}}
    end

    #                                      _ -> {:error, "unauthorized"}
    # end

    # case Menu.create_item(params) do
      # handling errors as data
      # {:error, changeset} -> {:ok, %{errors: transform_errors(changeset)}}
      # {:ok, menu_item}    -> {:ok, %{menu_item: menu_item}}

      # {:error, changeset} -> { :error, message: "Could not create menu item",
      #                                  details: error_details(changeset) }
      # {:ok, _} = success  -> success
    # end
  end

  def error_details(changeset) do
    changeset |> Ecto.Changeset.traverse_errors(fn {msg, _} -> msg end)
  end
end
