defmodule Rumbl.Category do
  use Rumbl.Web, :model

  schema "categories" do
    field :name, :string
    has_many :videos, Rumbl.Video

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end

  def order(query) do
    from c in query, order_by: c.name
  end

  def fields(query) do
    from c in query, select: {c.name, c.id}
  end
end
