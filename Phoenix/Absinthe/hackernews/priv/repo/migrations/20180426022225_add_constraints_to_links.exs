defmodule Hackernews.Repo.Migrations.AddConstraintsToLinks do
  use Ecto.Migration

  def change do
    alter table(:links) do
      modify :url, :string, null: false
    end
  end
end
