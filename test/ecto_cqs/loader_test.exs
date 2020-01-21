defmodule EctoCQS.LoaderTest do
  use EctoCQS.DataCase
  import EctoCQS.Helpers, only: [now: 0]
  alias EctoCQS.User.Loader

  describe "all_by/1" do
    test "returns users filtered using given expression" do
      now = now()

      user_1 =
        insert!(:user,
          name: "John",
          inserted_at: DateTime.add(now, 1, :second)
        )

      user_2 =
        insert!(:user,
          name: "John",
          inserted_at: DateTime.add(now, 2, :second)
        )

      _user_3 =
        insert!(:user,
          name: "Jane",
          inserted_at: DateTime.add(now, 3, :second)
        )

      assert Loader.all_by(name: "John") == [user_1, user_2]
    end
  end

  describe "all_ordered_by/1" do
    test "returns all users ordered using given expression" do
      now = now()
      user_1 = insert!(:user, inserted_at: DateTime.add(now, 1, :second))
      user_2 = insert!(:user, inserted_at: DateTime.add(now, 2, :second))

      assert Loader.all_ordered_by(desc: :inserted_at) == [user_2, user_1]
    end
  end

  describe "first/0" do
    test "returns first created user" do
      now = now()
      user_1 = insert!(:user, inserted_at: DateTime.add(now, 1, :second))
      _user_2 = insert!(:user, inserted_at: DateTime.add(now, 2, :second))

      assert Loader.first() == user_1
    end
  end

  describe "first/1" do
    test "returns first N created users" do
      now = now()
      user_1 = insert!(:user, inserted_at: DateTime.add(now, 1, :second))
      user_2 = insert!(:user, inserted_at: DateTime.add(now, 2, :second))
      _user_3 = insert!(:user, inserted_at: DateTime.add(now, 3, :second))

      assert Loader.first(2) == [user_1, user_2]
    end
  end

  describe "last/0" do
    test "returns last created user" do
      now = now()
      _user_1 = insert!(:user, inserted_at: DateTime.add(now, 1, :second))
      user_2 = insert!(:user, inserted_at: DateTime.add(now, 2, :second))

      assert Loader.last() == user_2
    end
  end

  describe "last/1" do
    test "returns last N created users" do
      now = now()
      _user_1 = insert!(:user, inserted_at: DateTime.add(now, 1, :second))
      user_2 = insert!(:user, inserted_at: DateTime.add(now, 2, :second))
      user_3 = insert!(:user, inserted_at: DateTime.add(now, 3, :second))

      assert Loader.last(2) == [user_3, user_2]
    end
  end

  describe "count/0" do
    test "returns count of all users" do
      insert!(:user)
      insert!(:user)

      assert Loader.count() == 2
    end
  end

  describe "count_by/0" do
    test "returns count of users filtered using given expression" do
      insert!(:user, name: "John")
      insert!(:user, name: "John")
      insert!(:user, name: "Jane")

      assert Loader.count_by(name: "John") == 2
    end
  end
end
