defmodule WrapTest.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :name, :string
    field :email, :string
    field :password, Comeonin.Ecto.Password
    has_many :links, WrapTest.Accounts.Link
    has_many :votes, WrapTest.Accounts.Vote

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:email, :password])
    |> validate_length(:password, min: 8)
    |> validate_format(:email, ~r/^\w+@\w+\.\w{2,}$/)
    |> unique_constraint(:email)
  end
end
