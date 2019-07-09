defmodule EctoCQS.MutatorTest do
  use EctoCQS.DataCase

  alias Ecto.Changeset
  alias EctoCQS.User
  alias EctoCQS.User.{Loader, Mutator}

  describe "insert/2" do
    test "inserts user (valid changeset)" do
      attrs = %{name: "John", age: 30}
      changeset = User.changeset(%User{}, attrs)
      assert {:ok, %User{id: id}} = Mutator.insert(changeset)

      user = Loader.get!(id)
      assert user.name == "John"
      assert user.age == 30
    end

    test "inserts user (valid attributes)" do
      attrs = %{name: "John", age: 30}
      assert {:ok, %User{id: id}} = Mutator.insert(attrs)

      user = Loader.get!(id)
      assert user.name == "John"
      assert user.age == 30
    end

    test "returns error changeset (invalid changeset)" do
      attrs = %{name: nil}
      changeset = User.changeset(%User{}, attrs)
      assert {:error, %Changeset{}} = Mutator.insert(changeset)
    end

    test "returns error changeset (invalid attributes)" do
      attrs = %{name: nil}
      assert {:error, %Changeset{}} = Mutator.insert(attrs)
    end
  end

  describe "insert_all/2" do
    test "inserts all users" do
      entries = [%{name: "John", age: 30}, %{name: "Jane", age: 31}]
      assert Mutator.insert_all(entries) == {2, nil}

      users = Loader.all()
      assert Enum.count(users) == 2

      assert Enum.at(users, 0).name == "John"
      assert Enum.at(users, 0).age == 30

      assert Enum.at(users, 1).name == "Jane"
      assert Enum.at(users, 1).age == 31
    end
  end

  describe "multi_insert/2" do
    test "returns empty changes when there are no changesets or entries" do
      assert {:ok, changes} = Mutator.multi_insert([])
      assert changes == %{}
    end

    test "inserts all users (valid changesets)" do
      entries = [%{name: "John", age: 30}, %{name: "Jane", age: 31}]
      changesets = Enum.map(entries, &User.changeset(%User{}, &1))
      assert {:ok, _changes} = Mutator.multi_insert(changesets)

      users = Loader.all()
      assert Enum.count(users) == 2

      assert Enum.at(users, 0).name == "John"
      assert Enum.at(users, 0).age == 30

      assert Enum.at(users, 1).name == "Jane"
      assert Enum.at(users, 1).age == 31
    end

    test "inserts all users (valid entries)" do
      entries = [%{name: "John", age: 30}, %{name: "Jane", age: 31}]
      assert {:ok, _changes} = Mutator.multi_insert(entries)

      users = Loader.all()
      assert Enum.count(users) == 2

      assert Enum.at(users, 0).name == "John"
      assert Enum.at(users, 0).age == 30

      assert Enum.at(users, 1).name == "Jane"
      assert Enum.at(users, 1).age == 31
    end

    test "returns Ecto.Multi error (one changeset is invalid)" do
      entries = [%{name: "John", age: 30}, %{name: nil, age: 31}]
      changesets = Enum.map(entries, &User.changeset(%User{}, &1))
      assert {:error, _, _, _} = Mutator.multi_insert(changesets)

      users = Loader.all()
      assert Enum.count(users) == 0
    end

    test "returns Ecto.Multi error (one entry is invalid)" do
      entries = [%{name: "John", age: 30}, %{name: nil, age: 31}]
      assert {:error, _, _, _} = Mutator.multi_insert(entries)

      users = Loader.all()
      assert Enum.count(users) == 0
    end
  end

  describe "multi_update/2" do
    test "returns empty changes when there are no changesets or entries" do
      assert {:ok, changes} = Mutator.multi_update([])
      assert changes == %{}
    end

    test "updates all users (valid changesets)" do
      user_1 = insert!(:user, name: "John", age: 30)
      user_2 = insert!(:user, name: "Jane", age: 31)

      changesets = [
        User.update_changeset(user_1, %{age: 31}),
        User.update_changeset(user_2, %{age: 32})
      ]

      assert {:ok, _changes} = Mutator.multi_update(changesets)

      users = Loader.all()
      assert Enum.count(users) == 2

      assert Enum.at(users, 0).name == "John"
      assert Enum.at(users, 0).age == 31

      assert Enum.at(users, 1).name == "Jane"
      assert Enum.at(users, 1).age == 32
    end

    test "returns Ecto.Multi error (one changeset is invalid)" do
      user_1 = insert!(:user, name: "John", age: 30)
      user_2 = insert!(:user, name: "Jane", age: 31)

      changesets = [
        User.update_changeset(user_1, %{age: 31}),
        User.update_changeset(user_2, %{age: nil})
      ]

      assert {:error, _, _, _} = Mutator.multi_update(changesets)

      users = Loader.all()
      assert Enum.count(users) == 2

      assert Enum.at(users, 0).name == "John"
      assert Enum.at(users, 0).age == 30

      assert Enum.at(users, 1).name == "Jane"
      assert Enum.at(users, 1).age == 31
    end
  end

  describe "update/2" do
    test "updates user (valid attributes)" do
      user = insert!(:user, name: "John", age: 30)
      assert {:ok, %User{}} = Mutator.update(user, %{age: 31})

      user = Loader.get!(user.id)
      assert user.age == 31
    end

    test "returns error changeset (invalid attributes)" do
      user = insert!(:user, name: "John", age: 30)

      assert {:error, %Changeset{}} = Mutator.update(user, %{age: nil})
      assert Loader.get!(user.id) == user
    end
  end

  describe "update_by_id/2" do
    test "updates user by ID" do
      user = insert!(:user, name: "John", age: 30)
      assert {:ok, %User{}} = Mutator.update_by_id(user.id, %{age: 31})

      user = Loader.get!(user.id)
      assert user.age == 31
    end
  end

  describe "update_all/1" do
    test "updates all users" do
      user_1 = insert!(:user, name: "John", age: 30)
      user_2 = insert!(:user, name: "Jane", age: 31)

      assert Mutator.update_all(%{age: 32}) == {2, nil}
      assert Loader.count() == 2

      user = Loader.get!(user_1.id)
      assert user.age == 32

      user = Loader.get!(user_2.id)
      assert user.age == 32
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
