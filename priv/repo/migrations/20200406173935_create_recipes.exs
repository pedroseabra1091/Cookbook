defmodule Cookbook.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  alias Cookbook.Recipe

  def change do
    Recipe.create_type()
    create table(:recipes) do
      add :name, :string, null: false
      add :steps, {:array, :text}, null: false
      add :cooking_time, :integer, null: false
      add :category, Recipe.type(), null: false
      add :portions, :integer, null: false

      timestamps()
    end
  end
end
