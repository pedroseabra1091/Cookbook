defmodule CookbookTest do
  use ExUnit.Case
  doctest Cookbook

  test "greets the world" do
    assert Cookbook.hello() == :world
  end
end
