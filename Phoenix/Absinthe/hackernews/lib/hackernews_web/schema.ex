defmodule HackernewsWeb.Schema do
  use Absinthe.Schema
  alias HackernewsWeb.Resolvers

  def middleware(middleware, field, object) do
    middleware |> apply(:errors, field, object)
               |> apply(:debug, field, object)
  end

  defp apply(middleware, :errors, _field, %{identifier: :mutation}) do
    middleware ++ [HackernewsWeb.Middleware.ChangesetErrors]
  end
  defp apply(middleware, :debug, _field, _object) do
    if System.get_env("DEBUG") do
       [{HackernewsWeb.Middleware.Debug, :start}] ++ middleware
    else
      middleware
    end
  end
  defp apply(middleware, _,_,_), do: middleware

  query do
    @desc "Lists all links"
    field :all_links, non_null(list_of(non_null(:link))) do
      resolve &Resolvers.Accounts.list_links/3
    end
  end

  mutation do
    @desc "Creates a new link"
    field :create_link, :link_result do
      arg :input, non_null(:link_input)
      resolve &Resolvers.Accounts.create_link/3
    end
    # field :create_vote, :vote
  end

  # subscription do
    #
  # end

  object :user do
    field :id, non_null(:id)
    field :name, non_null(:string)
  end

  object :link do
    field :id, non_null(:id)
    field :url, non_null(:string)
    field :description, :string
    field :posted_by, :user #returning null #how do I access `dataloader/1`?
  end #also `get-graphql-schema http://localhost:4000/api` fails to connect

  object :link_result do
    field :link, :link
    field :errors, list_of(:input_error)
  end

  input_object :link_input do
    field :url, non_null(:string)
    field :description, :string
    field :user_id, non_null(:id)
  end

  object :vote do
    field :id, non_null(:id)
    field :user, non_null(:user)
    field :link, non_null(:link)
  end

  object :input_error do
    field :key, non_null(:string)
    field :message, non_null(:string)
  end
end
