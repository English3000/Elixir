defmodule PlateSlateWeb.Resolvers.Menu do
  alias PlateSlate.Menu

  def menu_items(_, args, _) do
    {:ok, Menu.list_items(args)}
  end

  def items_for_category(category, _,_) do
    query = Ecto.assoc(category, :items)
    {:ok, PlateSlate.Repo.all(query)} # n+1 query (per category)
  end

  def search(_, %{match: term}, _) do
    {:ok, Menu.search(term)}
  end
end
