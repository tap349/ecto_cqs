# > <https://hexdocs.pm/ex_unit/ExUnit.DocTest.html>
# >
# > In general, doctests are not recommended when your code examples
# > contain side effects. For example, if a doctest prints to standard
# > output, doctest will not try to capture the output.
# >
# > Similarly, doctests do not run in any kind of sandbox.
#
# => don't use doctests
defmodule EctoCQS.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias EctoCQS.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import EctoCQS.Factory
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(EctoCQS.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(EctoCQS.Repo, {:shared, self()})
    end

    :ok
  end
end
