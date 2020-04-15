defmodule Cookbook.Repo.Migrations.AddIndexToRecipes do
  use Ecto.Migration

  def change do
    create index("recipes", :name)
  end
end
