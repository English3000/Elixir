defmodule HackernewsWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern #
  import Absinthe.Resolution.Helpers #incl's dataloader/2
  alias HackernewsWeb.Resolvers
  alias Hackernews.Accounts

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

  def plugins, do: [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults]

  def context(ctx), do: Map.put(ctx, :loader, dataloader())
  def dataloader(), do: Dataloader.new |> Dataloader.add_source(Accounts, Accounts.data())

  #=======
  query do
    field :me, :user, resolve: &Resolvers.Accounts.me/3 #
    # {
     # ​   me {
        # ​   name
        # ​   ... ​ on ​ Customer { orders { id } }
     # ​   }
     # ​   menuItems { name } ​  
    # }

    @desc "Lists all links"
    field :all_links, non_null(list_of(non_null(:link))) do
      resolve &Resolvers.Accounts.list_links/3
    end
  end

  object :user do
    field :id, non_null(:id)
    field :name, :string
    field :email, non_null(:string)
    field :password, non_null(:string)
  end

  object :link do
    field :id, non_null(:id)
    field :url, non_null(:string)
    field :description, :string
    field :posted_by, :user, resolve: dataloader(Accounts)
  end

  #==========
  mutation do
    field :sign_up, :session_result do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      resolve &Resolvers.Accounts.sign_up/3
      middleware HackernewsWeb.Middleware.CurrentUser
    end

    field :sign_in, :session_result do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      resolve &Resolvers.Accounts.sign_in/3
      middleware HackernewsWeb.Middleware.CurrentUser
    end #error may be handled improperly for wrong password

    field :update_user, :user do
      arg :name, non_null(:string)
      resolve &Resolvers.Accounts.update_user/3
      middleware HackernewsWeb.Middleware.CurrentUser
    end

    @desc "Creates a new link"
    field :create_link, :link_result do
      arg :input, non_null(:link_input)
      middleware HackernewsWeb.Middleware.Authorize
      resolve &Resolvers.Accounts.create_link/3
    end

    # field :create_vote, :vote
  end

  object :session_result do
    field :session, :session
    field :errors, list_of(:input_error)
  end

  object :session do
    field :token, :string
    field :user, :user
  end

  object :link_result do
    field :link, :link
    field :errors, list_of(:input_error)
  end

  input_object :link_input do
    field :url, non_null(:string)
    field :description, :string
    field :user_id, non_null(:id) #insert via middleware
  end

  object :input_error do
    field :key, non_null(:string)
    field :message, non_null(:string)
  end

  # #==============
  # subscription do
    #
  # end

  object :vote do
    field :id, non_null(:id)
    field :user, non_null(:user)
    field :link, non_null(:link)
  end
end
