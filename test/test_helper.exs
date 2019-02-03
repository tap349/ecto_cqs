{:ok, _pid} = EctoCQRS.Repo.start_link()

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(EctoCQRS.Repo, :manual)
