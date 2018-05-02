defmodule HackernewsWeb.Middleware.ChangesetErrors do
  @behaviour Absinthe.Middleware

  def call(resolution, _config) do #receives %Absinthe.Resolution{} struct & options
    with %{errors: [%Ecto.Changeset{} = changeset]} <- resolution do
      %{resolution | value: %{errors: transform_errors(changeset)}, errors: []}
    end# %{map | key: new_value}
  end

  defp transform_errors(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(&format_error/1)
    |> Enum.map(fn {key, value} -> %{key: key, message: value} end)
  end

  defp format_error({msg, options}) do
    Enum.reduce(options, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end
