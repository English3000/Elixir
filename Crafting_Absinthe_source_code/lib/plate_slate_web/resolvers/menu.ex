defmodule PlateSlateWeb.Resolvers.Menu do
  alias PlateSlate.Menu

  def menu_items(_, args, _) do
    {:ok, Menu.list_items(args)}
  end

  def items_for_category(category, _,_) do
    query = Ecto.assoc(category, :items)
    {:ok, PlateSlate.Repo.all(query)} # n+1 query (per category)
  end

  def search(_, %{match: term}, _) do
    {:ok, Menu.search(term)}
  end

  def create_item(_, %{input: params}, _) do
    case Menu.create_item(params) do
      # handling errors as data
      {:error, changeset} -> {:ok, %{errors: transform_errors(changeset)}}
      {:ok, menu_item}    -> {:ok, %{menu_item: menu_item}}

      # {:error, changeset} -> { :error, message: "Could not create menu item",
      #                                  details: error_details(changeset) }
      # {:ok, _} = success  -> success
    end
  end

  defp transform_errors(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(&format_error/1)
    |> Enum.map(fn {key, value} -> %{key: key, message: value} end)
  end

  @spec format_error(Ecto.Changeset.error) :: String.t
  defp format_error({msg, options}) do
    Enum.reduce(options, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end

  def error_details(changeset) do
    changeset |> Ecto.Changeset.traverse_errors(fn {msg, _} -> msg end)
  end
end
