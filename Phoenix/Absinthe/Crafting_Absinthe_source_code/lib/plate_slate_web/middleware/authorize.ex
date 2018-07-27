defmodule PlateSlateWeb.Middleware.Authorize do
  @behaviour Absinthe.Middleware

  def call(resolution, role) do
    with %{current_user: current_user} <- resolution.context,
                                  true <- roles_match?(current_user, role) do
      resolution
    else
      _ -> resolution |> Absinthe.Resolution.put_result({:error, "unauthorized"})
    end
  end

  defp roles_match?(%{}, :any),           do: true
  defp roles_match?(%{role: role}, role), do: true
  defp roles_match?(_,_),                 do: false
end
