defmodule PlateSlate.OrderingTest do
  use PlateSlate.DataCase, async: true

  alias PlateSlate.{Ordering, Repo}
  alias PlateSlate.Ordering.Order
  alias PlateSlate.Menu.Item

  setup do
    PlateSlate.Seeds.run()
  end

  describe "orders" do
    test "create_order/1 with valid data creates order" do
      chai = Repo.get_by!(Item, name: "Masala Chai")
      fries = Repo.get_by!(Item, name: "French Fries")

      data = %{ ordered_at: "2010-04-17 14:00:00.000000Z",
                state: "created",
                items: [ %{menu_item_id: chai.id, quantity: 1},
                         %{menu_item_id: fries.id, quantity: 2} ] }

      assert {:ok, %Order{} = order} = Ordering.create_order(data)

      assert Enum.map( order.items, &Map.take(&1, [:name, :quantity, :price]) ) ==
        [ %{name: "Masala Chai", quantity: 1, price: chai.price},
          %{name: "French Fries", quantity: 2, price: fries.price} ]

      assert order.state == "created"
    end

    # test "create_order/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = Ordering.create_order(@invalid_attrs)
    # end

    # def order_fixture(attrs \\ %{}) do
    #   {:ok, order} =
    #     attrs
    #     |> Enum.into(@valid_attrs)
    #     |> Ordering.create_order()
    #
    #   order
    # end
    #
    # test "list_orders/0 returns all orders" do
    #   order = order_fixture()
    #   assert Ordering.list_orders() == [order]
    # end
    #
    # test "get_order!/1 returns the order with given id" do
    #   order = order_fixture()
    #   assert Ordering.get_order!(order.id) == order
    # end

    # test "update_order/2 with valid data updates the order" do
    #   order = order_fixture()
    #   assert {:ok, order} = Ordering.update_order(order, @update_attrs)
    #   assert %Order{} = order
    #   assert order.customer_number == 43
    #   assert order.items == %{}
    #   assert order.ordered_at == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
    #   assert order.state == "some updated state"
    # end
    #
    # test "update_order/2 with invalid data returns error changeset" do
    #   order = order_fixture()
    #   assert {:error, %Ecto.Changeset{}} = Ordering.update_order(order, @invalid_attrs)
    #   assert order == Ordering.get_order!(order.id)
    # end
    #
    # test "delete_order/1 deletes the order" do
    #   order = order_fixture()
    #   assert {:ok, %Order{}} = Ordering.delete_order(order)
    #   assert_raise Ecto.NoResultsError, fn -> Ordering.get_order!(order.id) end
    # end
    #
    # test "change_order/1 returns a order changeset" do
    #   order = order_fixture()
    #   assert %Ecto.Changeset{} = Ordering.change_order(order)
    # end
  end
end
