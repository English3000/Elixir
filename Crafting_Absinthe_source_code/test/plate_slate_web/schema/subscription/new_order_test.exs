defmodule PlateSlateWeb.Schema.Subscription.NewOrderTest do
  use PlateSlateWeb.SubscriptionCase

  @signIn """
  mutation ($email: String!, $role: Role!) {
    signIn(role: $role, password: "super-secret", email: $email) { token }
  }
  """
  @subscription """
  subscription {
    newOrder {
      customerNumber
    }
  }
  """
  @mutation """
  mutation ($input: PlaceOrderInput!) {
    placeOrder(input: $input) {
      order { id }
    }
  }
  """

  test "can subscribe to new orders", %{socket: socket} do
    user = Factory.create_user("employee")
    ref = push_doc socket, @signIn,
            variables: %{"email" => user.email, "role" => "EMPLOYEE"}
    assert_reply ref, :ok, %{data: %{"signIn" => %{"token" => _}}}, 1000

    ref = push_doc socket, @subscription
    assert_reply ref, :ok, %{subscriptionId: subscription_id}

    order_input = %{ "customerNumber" => 24, "items" => [
      %{"quantity" => 2, "menuItemId" => menu_item("Reuben").id}
    ]}
    ref = push_doc socket, @mutation, variables: %{"input" => order_input}
    # No message matching %Phoenix.Socket.Reply{ref: ^ref, status: :ok, payload: reply} after 100ms.
      # The process mailbox is empty.
    assert_reply ref, :ok, reply
    assert %{data: %{"placeOrder" => %{"order" => %{"id" => _}}}} = reply

    expected = %{result: %{ data: %{"newOrder" => %{"customerNumber" => 24}}},
                            subscriptionId: subscription_id }

    assert_push "subscription:data", push
    assert expected == push
  end

  test "customers can't see other customers' orders", %{socket: socket} do
    customer1 = Factory.create_user("customer")
    ref = push_doc socket, @signIn, variables: %{ "email" => customer1.email,
                                                   "role" => "CUSTOMER" }
    assert_reply ref, :ok, %{data: %{"signIn" => %{"token" => _}}}, 1000

    ref = push_doc socket, @subscription
    assert_reply ref, :ok, %{subscriptionId: _s_id}

    place_order(customer1)
    assert_push "subscription:data", _

    customer2 = Factory.create_user("customer")
    place_order(customer2)
    refute_receive _
  end

  defp place_order(customer) do
    order_input = %{ "customerNumber" => 24,
                     "items" => [%{ "quantity" => 2,
                                    "menuItemId" => menu_item("Reuben").id }] }

    {:ok, %{data: %{"placeOrder" => _}}} = Absinthe.run(@mutation,
      PlateSlateWeb.Schema, [ context: %{current_user: customer},
                              variables: %{"input" => order_input} ] )
  end
end
