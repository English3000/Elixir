defmodule PlateSlateWeb.Schema.Mutation do
  use PlateSlateWeb.ConnCase, async: true
  alias PlateSlateWeb.ConnCase
  alias PlateSlate.{Repo, Menu}
  import Ecto.Query

  setup do
    PlateSlate.Seeds.run()

    category_id = from(t in Menu.Category, where: t.name == "Sandwiches")
      |> Repo.one!
      |> Map.fetch!(:id)
      |> to_string

    {:ok, category_id: category_id}
  end

  @query """
  mutation ($menuItem: MenuItemInput!) {
    createMenuItem(input: $menuItem) {
      errors { key message }
      menuItem {
        name
        description
        price
      }
    }
  }
  """

  @menu_item %{"name" => "French Dip", "price" => "5.75", "category_id" => "",
               "description" => "Roast beef, caramelized onions, horseradish, ..."}
  test "createMenuItem field creates an item", %{category_id: category_id} do
    menu_item = %{@menu_item | "category_id" => category_id}

    user = Factory.create_user("employee")
    conn = build_conn() |> ConnCase.auth_user(user)

    conn = post conn, "/api", query: @query, variables: %{"menuItem" => menu_item}
                                                      # v-- name of the mutation; can alias
    assert json_response(conn, 200) == %{ "data" => %{"createMenuItem" => %{
      "errors" => nil,
      "menuItem" => %{ "name" => menu_item["name"],
                       "description" => menu_item["description"],
                       "price" => menu_item["price"] }
    }} }
  end

  test "cannot create menu item with an existing name", %{category_id: category_id} do
    menu_item = %{@menu_item | "category_id" => category_id, "name" => "Reuben"}

    user = Factory.create_user("employee")
    conn = build_conn() |> ConnCase.auth_user(user)

    conn = post conn, "/api", query: @query, variables: %{"menuItem" => menu_item}

    assert json_response(conn, 200) == %{ "data" => %{"createMenuItem" => %{
      "errors" => [%{"key" => "name", "message" => "has already been taken"}],
      "menuItem" => nil
    }} }
  end

  test "customers cannot create menu items", %{category_id: category_id} do
    menu_item = %{@menu_item | "category_id" => category_id}

    user = Factory.create_user("customer")
    conn = build_conn() |> ConnCase.auth_user(user)

    conn = post conn, "/api", query: @query, variables: %{"menuItem" => menu_item}

    assert json_response(conn, 200) == %{
      "data" => %{"createMenuItem" => nil},
      "errors" => [%{ "locations" => [%{"column" => 0, "line" => 2}],
                      "message"   => "unauthorized",
                      "path"      => ["createMenuItem"] }]
    }
  end
end
