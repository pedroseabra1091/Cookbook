defmodule Cookbook.Repo.Migrations.CreateChefs do
  use Ecto.Migration

  def change do
    create table(:chefs) do
      add :name, :string

      timestamps()
    end
  end
end
