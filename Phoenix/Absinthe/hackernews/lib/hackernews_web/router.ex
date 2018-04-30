defmodule HackernewsWeb.Router do
  use HackernewsWeb, :router

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

  scope "/", HackernewsWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/create", PageController, :index
  end

  scope "/" do
    pipe_through :api

    forward "/api", Absinthe.Plug, schema: HackernewsWeb.Schema

    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: HackernewsWeb.Schema,
      interface: :simple
  end
end
