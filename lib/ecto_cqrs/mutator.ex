defmodule EctoCQRS.Mutator do
  defmacro __using__(opts) do
    repo = EctoCQRS.Helpers.repo(opts)
    schema = EctoCQRS.Helpers.schema(opts)

    quote do
      alias Ecto.Multi
      alias unquote(repo), as: Repo
      alias unquote(schema), as: Schema
      alias unquote(schema)
      alias unquote(:"#{schema}.Loader")

      # don't test delegating functions
      #
      # use Repo functions that don't require schema
      # (like Repo.delete/2) directly without Mutator
      defdelegate delete_all(schema \\ Schema), to: Repo

      def create(%Ecto.Changeset{} = changeset) do
        changeset
        |> Repo.insert()
      end

      def create(attrs) do
        %Schema{}
        |> Schema.changeset(attrs)
        |> Repo.insert()
      end

      def import(entries, precision \\ :second)

      def import(entries, precision) do
        timestamps = EctoCQRS.Helpers.timestamps(precision)
        entries = Enum.map(entries, &Map.merge(&1, timestamps))

        Schema
        |> Repo.insert_all(entries, returning: false)
      end

      defoverridable import: 2

      def update(%Schema{} = struct, attrs) do
        struct
        |> Schema.update_changeset(attrs)
        |> Repo.update()
      end

      # it takes about 5min to update 2.3M rows
      def update_all(attrs) do
        Schema
        |> Repo.update_all(set: Map.to_list(attrs))
      end

      def delete_by(clauses) do
        Schema
        |> EctoCQRS.Query.by(clauses)
        |> Repo.delete_all()
      end
    end
  end
end
