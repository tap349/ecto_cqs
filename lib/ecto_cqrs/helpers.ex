defmodule EctoCQRS.Helpers do
  def schema(opts) do
    opts
    |> Keyword.fetch!(:schema)
    |> Macro.expand(__ENV__)
  end

  def repo(opts) do
    case opts[:repo] do
      nil -> repo_from_schema(schema(opts))
      _ -> Macro.expand(opts[:repo], __ENV__)
    end
  end

  def now(precision \\ :second) do
    {:ok, now} = DateTime.now("Etc/UTC")
    DateTime.truncate(now, precision)
  end

  def timestamps(precision) do
    now = now(precision)
    %{inserted_at: now, updated_at: now}
  end

  defp repo_from_schema(schema) do
    schema
    |> Module.split()
    |> Enum.take(1)
    |> Kernel.++(["Repo"])
    |> Module.safe_concat()
  end
end
