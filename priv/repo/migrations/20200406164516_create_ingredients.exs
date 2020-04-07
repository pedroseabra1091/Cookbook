defmodule Cookbook.Repo.Migrations.CreateIngredients do
  use Ecto.Migration

  def change do
    create table(:ingredients) do
      add :name, :string

      timestamps(default: fragment("NOW()"))
    end
  end
end
