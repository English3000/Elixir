defmodule Hackernews.Accounts.Link do
  use Ecto.Schema
  import Ecto.Changeset


  schema "links" do
    field :url, :string
    field :description, :string
    belongs_to :posted_by, Hackernews.Accounts.User, foreign_key: :user_id
    has_many :votes, Hackernews.Accounts.Vote

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url])
    |> validate_required([:url])
    |> unique_constraint(:url)
    |> foreign_key_constraint(:user)
  end
end
