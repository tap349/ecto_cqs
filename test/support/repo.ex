defmodule EctoCQS.Repo do
  use Ecto.Repo,
    otp_app: :ecto_cqs,
    adapter: Ecto.Adapters.Postgres
end
