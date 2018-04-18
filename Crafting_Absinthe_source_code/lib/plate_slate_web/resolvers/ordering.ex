defmodule PlateSlateWeb.Resolvers.Ordering do
  alias PlateSlate.Ordering

  def place_order(_, %{input: place_order_input}, %{context: context}) do
    place_order_input = case context[:current_user] do
      %{role: "customer", id: id} -> Map.put(place_order_input, :customer_id, id)
                                _ -> place_order_input
    end

    with {:ok, order} <- Ordering.create_order(place_order_input) do
      Absinthe.Subscription.publish(PlateSlateWeb.Endpoint, order, new_order: [order.customer_id, "*"])
      {:ok, %{order: order}}
    end
  end

  def ready_order(_, %{id: id}, _) do
    order = Ordering.get_order!(id)

    with {:ok, order} <- Ordering.update_order(order, %{state: "ready"}) do
      {:ok, %{order: order}}
    end
  end

  def complete_order(_, %{id: id}, _) do
    order = Ordering.get_order!(id)

    with {:ok, order} <- Ordering.update_order(order, %{state: "complete"}) do
      {:ok, %{order: order}}
    end
  end
end
