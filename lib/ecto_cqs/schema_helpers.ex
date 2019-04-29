defmodule EctoCQS.SchemaHelpers do
  defmacro __using__(_opts) do
    quote do
      # https://blog.lelonek.me/form-objects-in-elixir-6a57cf7c3d30
      def cast(attrs) do
        fields = __MODULE__.__schema__(:fields)
        keys = Map.keys(attrs)

        %__MODULE__{}
        |> Ecto.Changeset.cast(attrs, fields)
        |> Ecto.Changeset.apply_changes()
        |> Map.from_struct()
        |> Map.take(keys)
      end
    end
  end
end
