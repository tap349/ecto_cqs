defmodule EctoCQRS.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias EctoCQRS.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import EctoCQRS.Factory
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(EctoCQRS.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(EctoCQRS.Repo, {:shared, self()})
    end

    :ok
  end
end
