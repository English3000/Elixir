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
  query ($filter: MenuItemFilter!) {
    menuItems(filter: $filter) {
      name
      addedOn
    }
  }
  """
  @variables %{filter: %{"added_before" => "2017-01-20"}}
  test "menuItems filtered by date (custom scalar type)" do
    sides = PlateSlate.Repo.get_by!(PlateSlate.Menu.Category, name: "Sides")
    %PlateSlate.Menu.Item{name: "Garlic Fries", added_on: ~D[2017-01-01],
                          price: 2.50, category: sides} |> PlateSlate.Repo.insert!

    response = get(build_conn(), "/api", query: @query, variables: @variables)
    assert json_response(response, 200) == %{"data" => %{
      "menuItems" => [%{"name" => "Garlic Fries", "addedOn" => "2017-01-01"}]
    } }
  end

  @variables %{filter: %{"added_before" => "2017"}}
  test "invalid addedOn field triggers error" do
    response = get(build_conn(), "/api", query: @query, variables: @variables)
    assert %{"errors" =>
              [%{"locations" => [%{"column" => 0, "line" => 2}],
                 "message"   => message}] } = json_response(response, 400)
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
