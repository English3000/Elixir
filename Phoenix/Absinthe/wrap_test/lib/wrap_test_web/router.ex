defmodule WrapTestWeb.Router do
  use WrapTestWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", WrapTestWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/" do
    pipe_through :api

    forward "/api", Absinthe.Plug, schema: WrapTestWeb.Schema

    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: WrapTestWeb.Schema,
      socket: WrapTestWeb.UserSocket
  end
end
