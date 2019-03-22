defmodule WrapTest.Repo.Migrations.CreateVotes do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :link_id, references(:links, on_delete: :delete_all)

      timestamps()
    end

    create index(:votes, [:user_id])
    create index(:votes, [:link_id])
  end
end
