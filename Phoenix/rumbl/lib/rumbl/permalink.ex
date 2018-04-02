defmodule Rumbl.Permalink do
  # a custom (data)type for `:id` field
  @behaviour Ecto.Type

  def type, do: :id

  def cast(binary) when is_binary(binary) do
    case Integer.parse(binary) do
      {num, _} when num > 0 -> {:ok, num}
      _ -> :error
    end
  end

  def cast(integer) when is_integer(integer), do: {:ok, integer}
  def cast(_), do: :error

  #VS
  # def cast(id) do
  #   cond do
  #     is_binary(id) -> {num, _} = Integer.parse(id)
  #       case num > 0 do
  #         true  -> {:ok, num}
  #         false -> :error
  #       end
  #     is_integer(id) -> {:ok, integer}
  #     _ -> :error
  #   end
  # end

  def dump(integer) when is_integer(integer) do
    {:ok, integer}
  end

  def load(integer) when is_integer(integer) do
    {:ok, integer}
  end
end
