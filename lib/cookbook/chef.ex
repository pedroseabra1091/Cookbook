defmodule Cookbook.Chef do
  use Ecto.Schema

  schema "chefs" do
    field :name, :string

    has_many :recipes, Cookbook.Recipe
  end
end