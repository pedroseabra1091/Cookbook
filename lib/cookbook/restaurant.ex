defmodule Cookbook.Restaurant do
  use Ecto.Schema

  alias Cookbook.Chef

  schema "restaurants" do
    field :name, :string

    belongs_to :chef, Chef

    timestamps()
  end
end