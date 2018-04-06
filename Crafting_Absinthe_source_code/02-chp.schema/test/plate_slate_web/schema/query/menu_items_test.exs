#---
# Excerpted from "Craft GraphQL APIs in Elixir with Absinthe",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/wwgraphql for more book information.
#---
defmodule PlateSlateWeb.Schema.Query.MenuItemsTest do
  use PlateSlateWeb.ConnCase, async: true

  setup do
    PlateSlate.Seeds.run()
  end

  @query """
  query ($filter: MenuItemFilter!) {
    menuItems(filter: $filter) {
      name
    }
  }
  """
  @variables %{filter: %{"name" => "reu"}}
  test "menuItems field returns menu items filtered by name" do
    response = get(build_conn(), "/api", query: @query, variables: @variables)
    assert json_response(response, 200) == %{"data" => %{
      "menuItems" => [%{"name" => "Reuben"}]
    } }
  end

  @variables %{filter: %{"name" => 123}}
  test "menuItems field returns errors for bad value" do
    response = get(build_conn(), "/api", query: @query, variables: @variables)
    assert %{"errors" => [%{"message" => message}]} = json_response(response, 400)
    assert String.contains?(message, "Argument \"filter\" has invalid value")
  end

  @variables %{filter: %{"category" => "Sandwiches", "tag" => "Vegetarian"}}
  test "menuItems field returns filtered menuItems (using a literal)" do
    response = get(build_conn(), "/api", query: @query, variables: @variables)
    assert json_response(response, 200) == %{"data" => %{
      "menuItems" => [%{"name" => "Vada Pav"}]
    } }
  end

  @query """
  query ($order: SortOrder!) {
    menuItems(order: $order) {
      name
    }
  }
  """
  @variables %{"order" => "DESC"}
  test "menuItems field returns menu items in descending order" do
    response = get(build_conn(), "/api", query: @query, variables: @variables)
    assert %{"data" => %{
      "menuItems" => [%{"name" => "Water"} | _]
    } } = json_response(response, 200)
  end

end
