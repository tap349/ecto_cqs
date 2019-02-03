defmodule EctoCQRS.Repo do
  use Ecto.Repo,
    otp_app: :ecto_cqrs,
    adapter: Ecto.Adapters.Postgres
end
