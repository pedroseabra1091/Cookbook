defmodule Cookbook.Repo.Migrations.AddChefIdToRecipes do
  use Ecto.Migration

  def change do
    # :delete_all does not cascade to child records unless set via database migrations.
    alter table(:recipes) do
      add :chef_id, references(:chefs, on_delete: :delete_all)
    end
  end
end
