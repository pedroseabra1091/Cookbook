import Config

config :cookbook, Cookbook.Repo,
  database: "cookbook_repo",
  hostname: "localhost"

config :cookbook, ecto_repos: [Cookbook.Repo]