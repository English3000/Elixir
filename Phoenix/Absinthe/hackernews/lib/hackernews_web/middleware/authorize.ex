defmodule HackernewsWeb.Middleware.Authorize do
  @behaviour Absinthe.Middleware

  def call(%{context: %{current_user: current_user}} = resolution, _) do
    case current_user do
       true -> resolution
      false -> resolution |> Absinthe.Resolution.put_result({:error, "unauthorized"})
    end
  end
end
