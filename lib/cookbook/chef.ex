defmodule Cookbook.Chef do
  use Ecto.Schema

  alias Cookbook.{Chef, Recipe, Repo}

  import Ecto.Changeset

  require IEx

  schema "chefs" do
    field :name, :string, null: false

    has_many :recipes, Recipe, on_delete: :delete_all

    timestamps()
  end

  def insert(params \\ %{}) do
    %Chef{}
    |> changeset(params)
    |> Repo.insert()
  end

  def update(chef, params \\ %{}) do
    chef
    |> changeset(params)
    |> Repo.update()
  end

  def delete(chef) do
    chef
    |> Repo.delete()
  end

  def changeset(chef, params) do
    chef
    |> cast(params, ~w(name)a)
    |> validate_required(~w(name)a)
    |> cast_assoc(:recipes, with: &Recipe.changeset/2)
  end
end