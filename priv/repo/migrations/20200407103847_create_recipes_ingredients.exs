defmodule Cookbook.Repo.Migrations.CreateRecipesIngredients do
  use Ecto.Migration

  def change do
    create table(:recipes_ingredients) do
      add :recipe_id, references(:recipes, on_delete: :delete_all)
      add :ingredient_id, references(:ingredients, on_delete: :delete_all)
    end

    create unique_index(:recipes_ingredients, [:recipe_id, :ingredient_id])
  end
end
