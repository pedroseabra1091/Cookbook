defmodule Cookbook.Chef do
  use Ecto.Schema

  alias Cookbook.{Recipe, Restaurant}

  schema "chefs" do
    field :name, :string, null: false

    has_many :restaurants, Restaurant, on_delete: :delete_all
    has_many :recipes, Recipe, on_delete: :nilify_all

    timestamps()
  end
end