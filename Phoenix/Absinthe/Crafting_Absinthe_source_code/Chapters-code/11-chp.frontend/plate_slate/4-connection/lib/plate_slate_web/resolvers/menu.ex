#---
# Excerpted from "Craft GraphQL APIs in Elixir with Absinthe",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/wwgraphql for more book information.
#---
defmodule PlateSlateWeb.Resolvers.Menu do
  alias PlateSlate.Menu
  import Absinthe.Resolution.Helpers

  def menu_items(_, args, _) do
    Absinthe.Relay.Connection.from_query(
      Menu.items_query(args),
      &PlateSlate.Repo.all/1,
      args
    )
  end

  def search(_, %{matching: term}, _) do
    {:ok, Menu.search(term)}
  end

  def get_item(_, %{id: id}, %{context: %{loader: loader}}) do
    loader
    |> Dataloader.load(Menu, Menu.Item, id)
    |> on_load(fn loader ->
      {:ok, Dataloader.get(loader, Menu, Menu.Item, id)}
    end)
  end

  def create_item(_, %{input: params}, _) do
    with {:ok, item} <- Menu.create_item(params) do
      {:ok, %{menu_item: item}}
    end
  end

end
