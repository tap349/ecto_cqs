defmodule EctoCQS.Loader do
  defmacro __using__(opts) do
    repo = EctoCQS.Helpers.repo(opts)
    schema = EctoCQS.Helpers.schema(opts)

    quote do
      # don't try to extract each and every query into schema Query -
      # write simple queries (which are not meant to be reused) right
      # inside schema Loader
      import Ecto.Query, warn: false

      alias Ecto.Multi
      alias unquote(repo), as: Repo
      alias unquote(schema), as: Schema
      alias unquote(schema)
      alias unquote(:"#{schema}.Query")

      # don't test delegating functions
      #
      # use Repo functions that don't require schema
      # (like Repo.preload/2) directly without Loader
      defdelegate all(schema \\ Schema), to: Repo
      defdelegate get(schema \\ Schema, id), to: Repo
      defdelegate get!(schema \\ Schema, id), to: Repo
      defdelegate get_by(schema \\ Schema, clauses), to: Repo

      def all_by(clauses) do
        Schema
        |> EctoCQS.Query.by(clauses)
        |> EctoCQS.Query.order_by(:inserted_at)
        |> Repo.all()
      end

      def all_ordered_by(expr) do
        Schema
        |> EctoCQS.Query.order_by(expr)
        |> Repo.all()
      end

      def first do
        Schema
        |> EctoCQS.Query.first()
        |> Repo.one()
      end

      def last do
        Schema
        |> EctoCQS.Query.last()
        |> Repo.one()
      end

      def count do
        Schema
        |> Repo.aggregate(:count, :id)
      end
    end
  end
end
