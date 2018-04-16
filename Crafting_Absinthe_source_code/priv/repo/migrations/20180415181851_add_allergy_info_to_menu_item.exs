defmodule PlateSlate.Repo.Migrations.AddAllergyInfoToMenuItem do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :allergy_info, :map
    end
  end
end
