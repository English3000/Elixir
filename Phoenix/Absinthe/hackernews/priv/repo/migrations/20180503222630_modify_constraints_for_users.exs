defmodule Hackernews.Repo.Migrations.ModifyConstraintsForUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      modify :name, :string, null: true
      modify :email, :string, null: false
      modify :password, :string, null: false
    end
  end
end
