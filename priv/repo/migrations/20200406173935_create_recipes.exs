defmodule Cookbook.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  alias Cookbook.Recipe

  def change do
    Recipe.create_type()
    create table(:recipes) do
      add :name, :string
      add :steps, {:array, :string}
      add :cooking_time, :integer
      add :category, Recipe.type()
      add :portions, :integer

      timestamps()
    end
  end
end
