defmodule EctoCQS.MutatorTest do
  use EctoCQS.DataCase

  alias Ecto.Changeset
  alias EctoCQS.User
  alias EctoCQS.User.{Loader, Mutator}

  describe "insert/2" do
    test "inserts user (valid changeset)" do
      attrs = %{name: "John", email: "john@example.com"}
      changeset = User.changeset(%User{}, attrs)
      assert {:ok, %User{id: id}} = Mutator.insert(changeset)

      user = Loader.get!(id)
      assert user.name == "John"
      assert user.email == "john@example.com"
    end

    test "inserts user (valid attributes)" do
      attrs = %{name: "John", email: "john@example.com"}
      assert {:ok, %User{id: id}} = Mutator.insert(attrs)

      user = Loader.get!(id)
      assert user.name == "John"
      assert user.email == "john@example.com"
    end

    test "returns error changeset (invalid changeset)" do
      attrs = %{name: nil, email: "john@example.com"}
      changeset = User.changeset(%User{}, attrs)
      assert {:error, %Changeset{}} = Mutator.insert(changeset)
    end

    test "returns error changeset (invalid attributes)" do
      attrs = %{name: nil, email: "john@example.com"}
      assert {:error, %Changeset{}} = Mutator.insert(attrs)
    end
  end

  describe "insert_all/2" do
    test "inserts all users" do
      entries = [
        %{name: "John", email: "john@example.com"},
        %{name: "Jane", email: "jane@example.com"}
      ]

      assert {2, nil} = Mutator.insert_all(entries)

      users = Loader.all()
      assert Enum.count(users) == 2

      assert Enum.at(users, 0).name == "John"
      assert Enum.at(users, 0).email == "john@example.com"

      assert Enum.at(users, 1).name == "Jane"
      assert Enum.at(users, 1).email == "jane@example.com"
    end
  end

  describe "multi_insert/2" do
    test "inserts all users (valid changesets)" do
      entries = [
        %{name: "John", email: "john@example.com"},
        %{name: "Jane", email: "jane@example.com"}
      ]

      changesets = Enum.map(entries, &User.changeset(%User{}, &1))
      assert {:ok, _changes} = Mutator.multi_insert(changesets)

      users = Loader.all()
      assert Enum.count(users) == 2

      assert Enum.at(users, 0).name == "John"
      assert Enum.at(users, 0).email == "john@example.com"

      assert Enum.at(users, 1).name == "Jane"
      assert Enum.at(users, 1).email == "jane@example.com"
    end

    test "inserts all users (valid entries)" do
      entries = [
        %{name: "John", email: "john@example.com"},
        %{name: "Jane", email: "jane@example.com"}
      ]

      assert {:ok, _changes} = Mutator.multi_insert(entries)

      users = Loader.all()
      assert Enum.count(users) == 2

      assert Enum.at(users, 0).name == "John"
      assert Enum.at(users, 0).email == "john@example.com"

      assert Enum.at(users, 1).name == "Jane"
      assert Enum.at(users, 1).email == "jane@example.com"
    end

    test "returns Ecto.Multi error (one changeset is invalid)" do
      entries = [
        %{name: "John", email: "john@example.com"},
        %{name: nil, email: "jane@example.com"}
      ]

      changesets = Enum.map(entries, &User.changeset(%User{}, &1))
      assert {:error, _, _, _} = Mutator.multi_insert(changesets)

      users = Loader.all()
      assert Enum.count(users) == 0
    end

    test "returns Ecto.Multi error (one entry is invalid)" do
      entries = [
        %{name: "John", email: "john@example.com"},
        %{name: nil, email: "jane@example.com"}
      ]

      assert {:error, _, _, _} = Mutator.multi_insert(entries)

      users = Loader.all()
      assert Enum.count(users) == 0
    end
  end

  describe "update/2" do
    test "updates user (valid attributes)" do
      user = insert!(:user, name: "John")
      assert {:ok, %User{}} = Mutator.update(user, %{name: "Jane"})

      user = Loader.get!(user.id)
      assert user.name == "Jane"
    end

    test "returns error changeset (invalid attributes)" do
      user = insert!(:user, name: "John")

      assert {:error, %Changeset{}} = Mutator.update(user, %{name: nil})
      assert Loader.get!(user.id) == user
    end
  end

  describe "update_by_id/2" do
    test "updates user by ID" do
      user = insert!(:user, name: "John")
      assert {:ok, %User{}} = Mutator.update_by_id(user.id, %{name: "Jane"})

      user = Loader.get!(user.id)
      assert user.name == "Jane"
    end
  end

  describe "update_all/1" do
    test "updates all users" do
      user_1 = insert!(:user, name: "John")
      user_2 = insert!(:user, name: "Jane")

      assert Mutator.update_all(%{name: "Jack"}) == {2, nil}
      assert Loader.count() == 2

      user = Loader.get!(user_1.id)
      assert user.name == "Jack"

      user = Loader.get!(user_2.id)
      assert user.name == "Jack"
    end
  end

  describe "delete_by/1" do
    test "deletes users filtered using given expression" do
      _user_1 = insert!(:user, name: "John")
      _user_2 = insert!(:user, name: "John")
      user_3 = insert!(:user, name: "Jane")

      assert Mutator.delete_by(name: "John") == {2, nil}
      assert Loader.all() == [user_3]
    end
  end
end
