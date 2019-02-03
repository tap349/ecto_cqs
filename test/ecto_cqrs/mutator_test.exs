defmodule EctoCQRS.MutatorTest do
  use EctoCQRS.DataCase

  alias Ecto.Changeset
  alias EctoCQRS.User
  alias EctoCQRS.User.{Loader, Mutator}

  test "create/1 with valid changeset creates user" do
    attrs = %{name: "John", email: "foo@example.com"}
    changeset = User.changeset(%User{}, attrs)

    assert {:ok, %User{id: id}} = Mutator.create(changeset)

    user = Loader.get!(id)
    assert user.name == "John"
    assert user.email == "foo@example.com"
  end

  test "create/1 with valid attributes creates user" do
    attrs = %{name: "John", email: "foo@example.com"}
    assert {:ok, %User{id: id}} = Mutator.create(attrs)

    user = Loader.get!(id)
    assert user.name == "John"
    assert user.email == "foo@example.com"
  end

  test "create/1 with invalid attributes returns error changeset" do
    attrs = %{name: nil, email: "foo@example.com"}
    assert {:error, %Changeset{}} = Mutator.create(attrs)
  end

  test "import/1 inserts all users" do
    entries = [
      %{name: "John", email: "foo@example.com"},
      %{name: "Jane", email: "bar@example.com"}
    ]

    assert {2, nil} = Mutator.import(entries)

    users = Loader.all()
    assert Enum.count(users) == 2

    assert Enum.at(users, 0).name == "John"
    assert Enum.at(users, 0).email == "foo@example.com"

    assert Enum.at(users, 1).name == "Jane"
    assert Enum.at(users, 1).email == "bar@example.com"
  end

  test "update/2 with valid attributes updates user" do
    user = insert!(:user, name: "John")
    assert {:ok, %User{}} = Mutator.update(user, %{name: "Jane"})

    user = Loader.get!(user.id)
    assert user.name == "Jane"
  end

  test "update/2 with invalid attributes returns error changeset" do
    user = insert!(:user, name: "John")

    assert {:error, %Changeset{}} = Mutator.update(user, %{name: nil})
    assert Loader.get!(user.id) == user
  end

  test "update_all/1 updates all users" do
    user_1 = insert!(:user, name: "John")
    user_2 = insert!(:user, name: "Jane")

    assert Mutator.update_all(%{name: "Jack"}) == {2, nil}
    assert Loader.count() == 2

    user = Loader.get!(user_1.id)
    assert user.name == "Jack"

    user = Loader.get!(user_2.id)
    assert user.name == "Jack"
  end

  test "delete_by/1 deletes all users matching given clauses" do
    _user_1 = insert!(:user, name: "John")
    _user_2 = insert!(:user, name: "John")
    user_3 = insert!(:user, name: "Jane")

    assert Mutator.delete_by(name: "John") == {2, nil}
    assert Loader.all() == [user_3]
  end
end
