defmodule GraphqlWeb.Router do
  use GraphqlWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: GraphqlWeb.Schema,
      interface: :simple,
      context: %{pubsub: GraphqlWeb.Endpoint}
  end
end
