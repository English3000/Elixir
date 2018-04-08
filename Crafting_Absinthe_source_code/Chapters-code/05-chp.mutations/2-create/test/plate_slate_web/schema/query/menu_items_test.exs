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
  {
    menuItems {
      name
    }
  }
  """
  test "menuItems field returns menu items" do
    conn = build_conn()
    conn = get conn, "/api", query: @query
    assert json_response(conn, 200) == %{"data" => %{"menuItems" => [
      %{"name" => "Bánh mì"},
      %{"name" => "Chocolate Milkshake"},
      %{"name" => "Croque Monsieur"},
      %{"name" => "French Fries"},
      %{"name" => "Lemonade"},
      %{"name" => "Masala Chai"},
      %{"name" => "Muffuletta"},
      %{"name" => "Papadum"},
      %{"name" => "Pasta Salad"},
      %{"name" => "Reuben"},
      %{"name" => "Soft Drink"},
      %{"name" => "Vada Pav"},
      %{"name" => "Vanilla Milkshake"},
      %{"name" => "Water"}
    ]}}
  end

  @query """
  {
    menuItems(filter: {name: "reu"}) {
      name
    }
  }
  """
  test "menuItems field returns menu items filtered by name" do
    response = get(build_conn(), "/api", query: @query)
    assert json_response(response, 200) == %{
      "data" => %{
        "menuItems" => [
          %{"name" => "Reuben"},
        ]
      }
    }
  end

  @query """
  {
    menuItems(filter: {name: 123}) {
      name
    }
  }
  """
  test "menuItems field returns errors when using a bad value" do
    response = get(build_conn(), "/api", query: @query)
    assert %{"errors" => [
      %{"message" => message}
    ]} = json_response(response, 400)
    assert message == "Argument \"filter\" has invalid value {name: 123}.\nIn field \"name\": Expected type \"String\", found 123."
  end

  @query """
  query ($term: String) {
    menuItems(filter: {name: $term}) {
      name
    }
  }
  """
  @variables %{"term" => "reu"} 
  test "menuItems field returns menuItems filtered by name when using a variable" do
    response = get(build_conn(), "/api", query: @query, variables: @variables) 
    assert json_response(response, 200) == %{
      "data" => %{
        "menuItems" => [
          %{"name" => "Reuben"},
        ]
      }
    }
  end

  @query """
  query ($term: String) {
    menuItems(filter: {name: $term}) {
      name
    }
  }
  """
  @variables %{"term" => 1} 
  test "menuItems field returns an error when using a bad variable value" do
    response = get(build_conn(), "/api", query: @query, variables: @variables)
    assert %{"errors" => _} = json_response(response, 400) 
  end


  @query """
  {
    menuItems(order: DESC) {
      name
    }
  }
  """
  test "menuItems field returns items descending using literals" do
    response = get(build_conn(), "/api", query: @query)
    assert %{
      "data" => %{"menuItems" => [%{"name" => "Water"} | _]}
    } = json_response(response, 200)
  end

  @query """
  {
    menuItems(order: ASC) {
      name
    }
  }
  """
  test "menuItems field returns items ascending using literals" do
    response = get(build_conn(), "/api", query: @query)
    assert %{
      "data" => %{"menuItems" => [%{"name" => "Bánh mì"} | _]}
    } = json_response(response, 200)
  end

  @query """
  {
    menuItems {
      name
    }
  }
  """
  test "menuItems field returns menuItems ascending when asked using the default value" do
    response = get(build_conn(), "/api", query: @query)
    assert %{"data" => %{"menuItems" => [%{"name" => "Bánh mì"} | _]}} = json_response(response, 200)
  end

  @query """
  query ($order: SortOrder!) { 
    menuItems(order: $order) {
      name
    }
  }
  """
  @variables %{"order" => "DESC"}
  test "menuItems field returns items descending using variables" do
    response = get(build_conn(), "/api", query: @query, variables: @variables)
    assert %{
      "data" => %{"menuItems" => [%{"name" => "Water"} | _]}
    } = json_response(response, 200)
  end

  @variables %{"order" => "ASC"}
  test "menuItems field returns items ascending using variables" do
    response = get(build_conn(), "/api", query: @query, variables: @variables)
    assert %{
      "data" => %{"menuItems" => [%{"name" => "Bánh mì"} | _]}
    } = json_response(response, 200)
  end

  @query """
  {
    menuItems(filter: {category: "Sandwiches", tag: "Vegetarian"}) {
      name
    }
  }
  """
  test "menuItems field returns menuItems, filtering with a literal" do
    response = get(build_conn(), "/api", query: @query)
    assert %{
      "data" => %{"menuItems" => [%{"name" => "Vada Pav"}]}
    } == json_response(response, 200)
  end

  @query """
  query ($filter: MenuItemFilter!) {
    menuItems(filter: $filter) {
      name
    }
  }
  """
  @variables %{filter: %{"tag" => "Vegetarian", "category" => "Sandwiches"}}
  test "menuItems field returns menuItems, filtering with a variable" do
    response = get(build_conn(), "/api", query: @query, variables: @variables)
    assert %{
      "data" => %{"menuItems" => [%{"name" => "Vada Pav"}]}
    } == json_response(response, 200)
  end

  @query """
  query ($filter: MenuItemFilter!) {
    menuItems(filter: $filter) {
      name
      addedOn
    }
  }
  """
  @variables %{filter: %{"addedBefore" => "2017-01-20"}}
  test "menuItems filtered by custom scalar" do
    sides = PlateSlate.Repo.get_by!(PlateSlate.Menu.Category, name: "Sides")
    %PlateSlate.Menu.Item{
      name: "Garlic Fries",
      added_on: ~D[2017-01-01],
      price: 2.50,
      category: sides
    } |> PlateSlate.Repo.insert!

    response = get(build_conn(), "/api", query: @query, variables: @variables)
    assert %{
      "data" => %{
        "menuItems" => [%{"name" => "Garlic Fries", "addedOn" => "2017-01-01"}]
      }
    } == json_response(response, 200)
  end

  @query """
  query ($filter: MenuItemFilter!) {
    menuItems(filter: $filter) {
      name
    }
  }
  """
  @variables %{filter: %{"addedBefore" => "not-a-date"}}
  test "menuItems filtered by custom scalar with error" do
    response = get(build_conn(), "/api", query: @query, variables: @variables)

    assert %{"errors" => [%{"locations" => [
      %{"column" => 0, "line" => 2}], "message" => message}
    ]} = json_response(response, 400)

    expected = """
    Argument "filter" has invalid value $filter.
    In field "addedBefore": Expected type "Date", found "not-a-date".\
    """
    assert expected == message
  end

  @query """
  query ($filter: MenuItemFilter!) {
    menuItems(filter: $filter) {
      name
    }
  }
  """
  @variables %{filter: %{"addedBefore" => 123}}
  test "menuItems filtered by custom scalar handles non strings" do
    response = get(build_conn(), "/api", query: @query, variables: @variables)
    assert %{
      "errors" => [%{"locations" => [%{"column" => 0, "line" => 2}], "message" => message}]
    } = json_response(response, 400)

    assert "Argument \"filter\" has invalid value $filter.\nIn field \"addedBefore\": Expected type \"Date\", found 123." == message
  end

end
