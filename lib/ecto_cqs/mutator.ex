defmodule EctoCQS.Mutator do
  defmacro __using__(opts) do
    repo = EctoCQS.Helpers.repo(opts)
    schema = EctoCQS.Helpers.schema(opts)

    quote do
      import Ecto.Query, warn: false

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

      def insert_all(entries, precision \\ :second, opts \\ [returning: false]) do
        timestamps = EctoCQS.Helpers.timestamps(precision)
        entries = Enum.map(entries, &Map.merge(&1, timestamps))

        Schema
        |> Repo.insert_all(entries, opts)
      end

      def update(%Schema{} = struct, attrs) do
        struct
        |> Schema.update_changeset(attrs)
        |> Repo.update()
      end

      def update_by_id(id, attrs) do
        id
        |> Loader.get!()
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
        |> where(^clauses)
        |> Repo.delete_all()
      end
    end
  end
end
