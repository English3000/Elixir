defmodule Rumbl.Annotation do
  use Rumbl.Web, :model

  schema "annotations" do
    field :body, :string
    field :at, :integer
    belongs_to :user, Rumbl.User, foreign_key: :user_id
    belongs_to :video, Rumbl.Video, foreign_key: :video_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:body, :at])
    |> validate_required([:body, :at])
  end
end
