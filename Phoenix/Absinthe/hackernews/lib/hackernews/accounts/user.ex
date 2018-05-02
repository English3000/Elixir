defmodule Hackernews.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :name, :string
    field :email, :string
    field :password, Comeonin.Ecto.Password
    has_many :links, Hackernews.Accounts.Link
    has_many :votes, Hackernews.Accounts.Vote

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> unique_constraint(:name)
    |> unique_constraint(:email)
  end
end
