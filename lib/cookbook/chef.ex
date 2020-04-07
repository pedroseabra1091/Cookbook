defmodule Cookbook.Chef do
  use Ecto.Schema

  alias Cookbook.{Recipe, Restaurant}

  schema "chefs" do
    field :name, :string, null: false

    has_many :restaurants, Restaurant
    has_many :recipes, Recipe

    timestamps()
  end
end