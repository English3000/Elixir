defmodule PlateSlateWeb.Schema.Subscription.UpdateOrderTest do
  use PlateSlateWeb.SubscriptionCase
  alias PlateSlate.Ordering

  @subscription """
  subscription ($id: ID!) {
    updateOrder(id: $id) { state }
  }
  """
  @mutation """
  mutation ($id: ID!) {
    readyOrder(id: $id) {
      errors { message }
    }
  }
  """

  test "subscribe to order updates", %{socket: socket} do
    reuben = menu_item("Reuben")
    {:ok, order1} = Ordering.create_order(%{ customer_number: 123,
                      items: [%{menu_item_id: reuben.id, quantity: 2}] })

    {:ok, order2} = Ordering.create_order(%{ customer_number: 124,
                      items: [%{menu_item_id: reuben.id, quantity: 1}] })
  end
end
