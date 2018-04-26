defmodule Hackernews.Repo.Migrations.AddDescriptionToLinks do
  use Ecto.Migration

  def change do
    alter table(:links) do
      add :description, :string #forgot to make first 3 migrations' fields `null: false`
    end
  end
end
