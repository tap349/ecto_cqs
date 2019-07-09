defmodule EctoCQS.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :age, :integer

    timestamps(type: :utc_datetime)
  end

  @create_permitted_fields ~w(name age)a
  @update_permitted_fields ~w(age)a
  @required_fields @create_permitted_fields

  def changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, @create_permitted_fields)
    |> validate_required(@required_fields)
  end

  def update_changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, @update_permitted_fields)
    |> validate_required(@required_fields)
  end
end
