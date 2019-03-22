defmodule WrapTest.Accounts.Link do
  use Ecto.Schema
  import Ecto.Changeset


  schema "links" do
    field :url, :string
    field :description, :string
    belongs_to :posted_by, WrapTest.Accounts.User, foreign_key: :user_id
    has_many :votes, WrapTest.Accounts.Vote

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url, :description])
    |> validate_required([:url])
    |> foreign_key_constraint(:user)
  end
end
