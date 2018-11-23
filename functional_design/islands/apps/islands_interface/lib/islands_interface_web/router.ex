defmodule IslandsInterfaceWeb.Router do
  use IslandsInterfaceWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :signed_in?
  end
  # Protects against accessing game via query string.
  # TODO: Unfortunately, redirects if server crashes...
  defp signed_in?(%{assigns: %{game: _, player: _}} = conn, _opts), do: conn
  defp signed_in?(conn, _opts) do
    case Map.get(conn, :query_string) do
      "" -> conn

      _  -> conn
            |> Map.put(:query_params, %{})
            |> Map.put(:query_string, "")
            |> Phoenix.Controller.redirect(to: "/")
            |> halt()
    end
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", IslandsInterfaceWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", IslandsInterfaceWeb do
  #   pipe_through :api
  # end
end
