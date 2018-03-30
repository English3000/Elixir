defmodule Rumbl.Video do
  use Rumbl.Web, :model

  schema "videos" do
    field :url, :string
    field :title, :string
    field :description, :string
    belongs_to :user, Rumbl.User, foreign_key: :user_id
    belongs_to :category, Rumbl.User, foreign_key: :category_id #optional

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:url, :title, :description])
    |> validate_required([:url, :title, :description])
    |> assoc_constraint(:category)
  end
end
