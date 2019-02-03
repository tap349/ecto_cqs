use Mix.Config

config :ecto_cqrs, ecto_repos: [EctoCQRS.Repo]

# see docker-compose.yml
config :ecto_cqrs, EctoCQRS.Repo,
  username: "postgres",
  password: "postgres",
  database: "ecto_cqrs_test",
  hostname: "localhost",
  port: 5442,
  pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :warn
