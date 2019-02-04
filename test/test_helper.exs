{:ok, _pid} = EctoCQS.Repo.start_link()

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(EctoCQS.Repo, :manual)
