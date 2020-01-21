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

      # use Repo functions that don't require schema
      # (like Repo.preload/2) directly without Loader

      def all do
        default_scope()
        |> Repo.all()
      end

      def get(id) do
        default_scope()
        |> Repo.get(id)
      end

      def get!(id) do
        default_scope()
        |> Repo.get!(id)
      end

      def get_by(expr) do
        default_scope()
        |> Repo.get_by(expr)
      end

      def get_by!(expr) do
        default_scope()
        |> Repo.get_by!(expr)
      end

      def all_by(expr) do
        default_scope()
        |> where(^expr)
        |> order_by(:inserted_at)
        |> Repo.all()
      end

      def all_ordered_by(expr) do
        default_scope()
        |> order_by(^expr)
        |> Repo.all()
      end

      def first do
        default_scope()
        |> EctoCQS.Query.first()
        |> Repo.one()
      end

      def first(limit) do
        default_scope()
        |> order_by(:inserted_at)
        |> limit(^limit)
        |> Repo.all()
      end

      def last do
        default_scope()
        |> EctoCQS.Query.last()
        |> Repo.one()
      end

      def last(limit) do
        default_scope()
        |> order_by(desc: :inserted_at)
        |> limit(^limit)
        |> Repo.all()
      end

      def count do
        default_scope()
        |> Repo.aggregate(:count, :id)
      end

      def count_by(expr) do
        default_scope()
        |> where(^expr)
        |> Repo.aggregate(:count, :id)
      end

      def default_scope do
        Schema
      end

      defoverridable default_scope: 0
    end
  end
end
