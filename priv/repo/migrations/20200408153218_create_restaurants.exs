defmodule Cookbook.Repo.Migrations.CreateRestaurants do
  use Ecto.Migration

  def change do
    create table(:restaurants) do
      add :name, :string
      add :location, :string
      add :chef_id, references(:chefs, on_delete: :delete_all)

      timestamps()
    end
  end
end
