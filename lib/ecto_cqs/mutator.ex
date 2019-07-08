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

      @default_insert_opts [returning: false]

      # don't test delegating functions
      #
      # use Repo functions that don't require schema
      # (like Repo.delete/2) directly without Mutator
      defdelegate delete_all(schema \\ Schema), to: Repo

      def insert(changeset_or_attrs, opts \\ [])

      def insert(%Ecto.Changeset{} = changeset, opts) do
        opts = Keyword.merge(@default_insert_opts, opts)

        changeset
        |> Repo.insert(opts)
      end

      def insert(attrs, opts) do
        %Schema{}
        |> Schema.changeset(attrs)
        |> insert(opts)
      end

      def insert_all(entries, opts \\ []) do
        timestamps = EctoCQS.Helpers.timestamps(:second)
        entries = Enum.map(entries, &Map.merge(&1, timestamps))
        opts = Keyword.merge(@default_insert_opts, opts)

        Schema
        |> Repo.insert_all(entries, opts)
      end

      def multi_insert(changesets_or_entries, opts \\ [])

      def multi_insert([], opts), do: {:ok, %{}}

      def multi_insert([%Ecto.Changeset{} | _] = changesets, opts) do
        opts = Keyword.merge(@default_insert_opts, opts)

        changesets
        |> Enum.with_index()
        |> Enum.reduce(Multi.new(), fn {changeset, i}, acc ->
          Multi.insert(acc, i, changeset, opts)
        end)
        |> Repo.transaction()
      end

      def multi_insert(entries, opts) do
        entries
        |> Enum.map(&Schema.changeset(%Schema{}, &1))
        |> multi_insert(opts)
      end

      def multi_update(changesets, opts \\ [])

      def multi_update([], opts), do: {:ok, %{}}

      def multi_update([%Ecto.Changeset{} | _] = changesets, opts) do
        changesets
        |> Enum.with_index()
        |> Enum.reduce(Multi.new(), fn {changeset, i}, acc ->
          Multi.update(acc, i, changeset, opts)
        end)
        |> Repo.transaction()
      end

      def update(%Schema{} = struct, attrs) do
        struct
        |> Schema.update_changeset(attrs)
        |> Repo.update()
      end

      # http://blog.tap349.com/elixir/ecto/2018/12/28/ecto-tips/#how-to-to-update-record-by-id
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

      def delete_by(expr) do
        Schema
        |> where(^expr)
        |> Repo.delete_all()
      end
    end
  end
end
