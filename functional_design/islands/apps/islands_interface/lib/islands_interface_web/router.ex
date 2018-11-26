defmodule IslandsInterfaceWeb.Router do
  use IslandsInterfaceWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :block_query
  end
  # Protects against accessing game via query string.
  defp block_query(conn, _opts) do
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
