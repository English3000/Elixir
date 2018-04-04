#---
# Excerpted from "Craft GraphQL APIs in Elixir with Absinthe",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/wwgraphql for more book information.
#---
defmodule PlateSlate.Seeds do

  def run() do
    alias PlateSlate.{Menu, Repo}

    #
    # TAGS
    #

    vegetarian =
      %Menu.ItemTag{name: "Vegetarian"}
      |> Repo.insert!

    _vegan =
      %Menu.ItemTag{name: "Vegan"}
      |> Repo.insert!

    _gluten_free =
      %Menu.ItemTag{name: "Gluten Free"}
      |> Repo.insert!

    #
    # SANDWICHES
    #

    sandwiches = %Menu.Category{name: "Sandwiches"} |> Repo.insert!

    _rueben =
      %Menu.Item{name: "Reuben", price: 4.50, category: sandwiches}
      |> Repo.insert!

    _croque =
      %Menu.Item{name: "Croque Monsieur", price: 5.50, category: sandwiches}
      |> Repo.insert!

    _muffuletta =
      %Menu.Item{name: "Muffuletta", price: 5.50, category: sandwiches}
      |> Repo.insert!

    _bahn_mi =
      %Menu.Item{name: "Bánh mì", price: 4.50, category: sandwiches}
      |> Repo.insert!

    _vada_pav =
      %Menu.Item{name: "Vada Pav", price: 4.50, category: sandwiches, tags: [vegetarian]}
      |> Repo.insert!

    #
    # SIDES
    #

    sides = %Menu.Category{name: "Sides"} |> Repo.insert!

    _fries =
      %Menu.Item{name: "French Fries", price: 2.50, category: sides}
      |> Repo.insert!

    _papadum =
      %Menu.Item{name: "Papadum", price: 1.25, category: sides}
      |> Repo.insert!

    _pasta_salad =
      %Menu.Item{name: "Pasta Salad", price: 2.50, category: sides}
      |> Repo.insert!

    category = Repo.get_by(Menu.Category, name: "Sides")
    %Menu.Item{
      name: "Thai Salad",
      price: 3.50,
      category: category,
      allergy_info: [
        %{"allergen" => "Peanuts", "severity" => "Contains"},
        %{"allergen" => "Shell Fish", "severity" => "Shared Equipment"},
      ]
    } |> Repo.insert!

    #
    # BEVERAGES
    #

    beverages = %Menu.Category{name: "Beverages"} |> Repo.insert!

    _water =
      %Menu.Item{name: "Water", price: 0, category: beverages}
      |> Repo.insert!

    _soda =
      %Menu.Item{name: "Soft Drink", price: 1.5, category: beverages}
      |> Repo.insert!

    _lemonade =
      %Menu.Item{name: "Lemonade", price: 1.25, category: beverages}
      |> Repo.insert!

    _chai =
      %Menu.Item{name: "Masala Chai", price: 1.5, category: beverages}
      |> Repo.insert!

    _vanilla_milkshake =
      %Menu.Item{name: "Vanilla Milkshake", price: 3.0, category: beverages}
      |> Repo.insert!

    _chocolate_milkshake =
      %Menu.Item{name: "Chocolate Milkshake", price: 3.0, category: beverages}
      |> Repo.insert!

    if Mix.env == :dev do
      fries = Menu.Item |> Repo.get_by!(name: "French Fries")
      chai = Menu.Item |> Repo.get_by!(name: "Masala Chai")
      chocolate_milkshake = Menu.Item |> Repo.get_by!(name: "Chocolate Milkshake")

      {:ok, _} = PlateSlate.Ordering.create_order(%{
        customer_number: 42,
        ordered_at: "2017-04-17 14:00:00.000000Z",
        state: "completed",
        items: [
          %{menu_item_id: fries.id, quantity: 1},
          %{menu_item_id: chai.id, quantity: 2},
        ]
      })

      {:ok, _} = PlateSlate.Ordering.create_order(%{
        customer_number: 43,
        ordered_at: "2017-11-01 14:00:00.000000Z",
        state: "completed",
        items: [
          %{menu_item_id: chocolate_milkshake.id, quantity: 2},
        ]
      })

      {:ok, _} = PlateSlate.Ordering.create_order(%{
        customer_number: 44,
        ordered_at: "2017-11-01 14:00:00.000000Z",
        state: "completed",
        items: [
          %{menu_item_id: chocolate_milkshake.id, quantity: 2},
        ]
      })

      %PlateSlate.Accounts.User{}
      |> PlateSlate.Accounts.User.changeset(%{
        email: "user@localhost",
        password: "12345",
        name: "Alicia",
        role: "employee",
      })
      |> Repo.insert!
    end

    :ok
  end
end
