defmodule Rumbl.User do
  use Rumbl.Web, :model

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_many :videos, Rumbl.Video

    timestamps()
  end

  # for authentication
  def registration_changeset(model, params \\ %{}) do
    model
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pw_hash()
  end

  # (Ecto.CastError) expected params to be a :map, got: `:empty`
  # DEPRECATED: https://medium.com/@peterbanjo/ecto-changeset-deprecates-empty-268dbd569144
  def changeset(model, params \\ %{}) do
    model
    # params, req'd fields, opt. fields
    |> cast(params, [:name, :username], [])
    # need this to handle empty fields
    |> validate_required([:name, :username])
    |> validate_length(:username, min: 1, max: 20)
    |> unique_constraint(:username)
  end

  defp put_pw_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pw}} ->
        put_change( changeset, :password_hash,
                    Comeonin.Bcrypt.hashpwsalt(pw) )
      _ -> changeset
    end
  end
end
