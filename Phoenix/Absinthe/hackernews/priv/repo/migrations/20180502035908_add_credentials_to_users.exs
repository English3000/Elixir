defmodule Hackernews.Repo.Migrations.AddCredentialsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :email, :string
      add :password, :string
    end

    create unique_index(:users, [:email])
  end
end
