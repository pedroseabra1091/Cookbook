defmodule Cookbook.Repo.Migrations.CreateIngredients do
  use Ecto.Migration

  alias Cookbook.Ingredient

  def change do
    Ingredient.create_type()
    create table(:ingredients) do
      add :name, :string, null: false
      add :measure_unit, Ingredient.type()

      timestamps(default: fragment("NOW()"))
    end

    create unique_index(:ingredients, [:name])
  end
end
