defmodule Cookbook.Repo.Migrations.AddChefIdToRecipes do
  use Ecto.Migration

  def change do
    alter table(:recipes) do
      add :chef_id, references(:chefs)
    end
  end
end
