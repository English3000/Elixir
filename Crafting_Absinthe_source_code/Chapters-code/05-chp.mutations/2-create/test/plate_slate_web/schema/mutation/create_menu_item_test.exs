#---
# Excerpted from "Craft GraphQL APIs in Elixir with Absinthe",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/wwgraphql for more book information.
#---
defmodule PlateSlateWeb.Schema.Mutation.CreateMenuTest do
  use PlateSlateWeb.ConnCase, async: true

  alias PlateSlate.{Repo, Menu}
  import Ecto.Query

  setup do
    PlateSlate.Seeds.run()

    category_id =
      from(t in Menu.Category, where: t.name == "Sandwiches")
      |> Repo.one!
      |> Map.fetch!(:id)
      |> to_string

    {:ok, category_id: category_id}
  end

  @query """
  mutation ($menuItem: MenuItemInput!) {
    createMenuItem(input: $menuItem) {
      name
      description
      price
    }
  }
  """
  test "createMenuItem field creates an item", %{category_id: category_id} do
    menu_item = %{
      "name" => "French Dip",
      "description" => "Roast beef, caramelized onions, horseradish, ...",
      "price" =>  "5.75",
      "categoryId" => category_id,
    }
    conn = build_conn()
    conn = post conn, "/api",
      query: @query,
      variables: %{"menuItem" => menu_item}

    assert json_response(conn, 200) == %{
      "data" => %{
       "createMenuItem" => %{
          "name" => menu_item["name"],
          "description" => menu_item["description"],
          "price" => menu_item["price"]
        }
      }
    }
  end

end
