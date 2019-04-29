# generate migrations with `MIX_ENV=test` because
# repo module is defined for test environment only:
#
# $ MIX_ENV=test mix ecto.gen.migration create_users
defmodule EctoCQS.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :age, :integer, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
