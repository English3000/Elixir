defmodule Hackernews.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :url, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:links, [:user_id])
  end
end
