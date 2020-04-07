defmodule Cookbook.Repo.Migrations.CreateRestaurants do
  use Ecto.Migration

  def change do
    create table(:restaurants) do
      add :name, :string
      add :chef_id, references(:chefs)

      timestamps()
    end
  end
end
