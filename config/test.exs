use Mix.Config

config :ecto_cqs, ecto_repos: [EctoCQS.Repo]

# see docker-compose.yml
config :ecto_cqs, EctoCQS.Repo,
  username: "postgres",
  password: "postgres",
  database: "ecto_cqs_test",
  hostname: "localhost",
  port: 5442,
  pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :warn
