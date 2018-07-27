defmodule Strain do
  @doc """
  Recursively deletes all instances of `item` in `list`.
  """
  def delete_all(list, item) do
    list = List.delete(list, item)
    case !!Enum.find(list, &(&1 == item)) do
      true -> delete_all(list, item)
      false -> list
    end
  end

  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns true.

  Do not use `Enum.filter`.
  """
  @spec keep(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def keep(list, fun) do
    filtered = Enum.map(list, fn(item) ->
      case fun.(item) do
        true -> item
        false -> []
      end
    end)

    delete_all(filtered, [])
  end

  @doc """
  Given a `list` of items and a function `fun`, return the list of items where
  `fun` returns false.

  Do not use `Enum.reject`.
  """
  @spec discard(list :: list(any), fun :: (any -> boolean)) :: list(any)
  def discard(list, fun) do
    filtered = Enum.map(list, fn(item) ->
      case fun.(item) do
        false -> item
        true -> []
      end
    end)

    delete_all(filtered, [])
  end
end
