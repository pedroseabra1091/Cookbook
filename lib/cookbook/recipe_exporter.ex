defmodule Cookbook.RecipeExporter do
  @columns ~w(name cooking_time category portions)a
  @path File.cwd! <> "/recipe.csv"

  alias Cookbook.Repo

  def export(query) do
    Repo.transaction(fn ->
      query
      |> Repo.stream
      |> Stream.map(&(&1))
      |> CSV.encode(headers: @columns)
      |> Enum.into(File.stream!(@path, [:write, :utf8]))
    end)
  end
end