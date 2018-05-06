defmodule HackernewsWeb.Middleware.CurrentUser do
  @behaviour Absinthe.Middleware

  def call(resolution, _) do
    with %{value: %{user: user}} <- resolution do
      %{resolution | context: Map.put(resolution.context, :current_user, user)}
    end
  end
end
