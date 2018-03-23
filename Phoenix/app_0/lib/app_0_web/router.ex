defmodule App0Web.Router do
  use App0Web, :router

  pipeline :browser do
    plug :accepts, ["html"] # add other file ext's here
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", App0Web do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/hello", HelloController, :index
    # Notice that we put the atom :messenger in the path. Phoenix will take whatever value that appears in that position in the URL and pass a Map with the key messenger pointing to that value to the controller.
    get "/hello/:messenger", HelloController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", App0Web do
  #   pipe_through :api
  # end
end
