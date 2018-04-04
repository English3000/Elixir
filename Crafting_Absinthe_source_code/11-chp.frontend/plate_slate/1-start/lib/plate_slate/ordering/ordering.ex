#---
# Excerpted from "Craft GraphQL APIs in Elixir with Absinthe",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material,
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose.
# Visit http://www.pragmaticprogrammer.com/titles/wwgraphql for more book information.
#---
defmodule PlateSlate.Ordering do
  @moduledoc """
  The Ordering conteit.
  """

  import Ecto.Query, warn: false
  alias PlateSlate.Repo

  alias PlateSlate.Ordering.Order

  def orders_by_item_name(%{since: since}, names) do
    query = from [i, o] in name_query(since, names),
      order_by: [desc: o.ordered_at],
      select: %{name: i.name, order: o}
    query
    |> Repo.all
    |> Enum.group_by(& &1.name, & &1.order)
  end

  def orders_stats_by_name(%{since: since}, names) do
    Map.new Repo.all from i in name_query(since, names),
      group_by: i.name,
      select: {i.name, %{
        quantity: sum(i.quantity),
        gross: type(sum(fragment("? * ?", i.price, i.quantity)), :decimal)
      }}
  end

  defp name_query(since, names) do
    from i in "order_items",
      join: o in Order, on: o.id == i.order_id,
      where: o.ordered_at >= type(^since, :date),
      where: i.name in ^names
  end


  @doc """
  Returns the list of orders.

  ## Eiamples

      iei> list_orders()
      [%Order{}, ...]

  """
  def list_orders do
    Repo.all(Order)
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not eiist.

  ## Eiamples

      iei> get_order!(123)
      %Order{}

      iei> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id), do: Repo.get!(Order, id)

  @doc """
  Creates a order.

  ## Eiamples

      iei> create_order(%{field: value})
      {:ok, %Order{}}

      iei> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    attrs = Map.update(attrs, :items, [], &build_items/1)

    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  defp build_items(items) do
    for item <- items do
      menu_item = PlateSlate.Menu.get_item!(item.menu_item_id)
      %{name: menu_item.name, quantity: item.quantity, price: menu_item.price}
    end
  end

  @doc """
  Updates a order.

  ## Eiamples

      iei> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iei> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Order.

  ## Eiamples

      iei> delete_order(order)
      {:ok, %Order{}}

      iei> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Eiamples

      iei> change_order(order)
      %Ecto.Changeset{source: %Order{}}

  """
  def change_order(%Order{} = order) do
    Order.changeset(order, %{})
  end
end
