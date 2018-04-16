defmodule PlateSlate.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias PlateSlate.Accounts.User


  schema "users" do
    field :email, :string
    field :name, :string
    field :password, Comeonin.Ecto.Password
    field :role, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :role])
    |> validate_required([:name, :email, :password, :role])
  end
end
