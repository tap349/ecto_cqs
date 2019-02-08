defmodule EctoCQS.LoaderTest do
  use EctoCQS.DataCase
  import EctoCQS.Helpers, only: [now: 0]
  alias EctoCQS.User.Loader

  test "all_by/1 returns all users matching given clauses" do
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

  test "all_ordered_by/1 returns all users sorted using given expression" do
    now = now()
    user_1 = insert!(:user, inserted_at: DateTime.add(now, 1, :second))
    user_2 = insert!(:user, inserted_at: DateTime.add(now, 2, :second))

    assert Loader.all_ordered_by(desc: :inserted_at) == [user_2, user_1]
  end

  test "first/0 returns first created client" do
    now = now()
    user_1 = insert!(:user, inserted_at: DateTime.add(now, 1, :second))
    _user_2 = insert!(:user, inserted_at: DateTime.add(now, 2, :second))

    assert Loader.first() == user_1
  end

  test "last/0 returns last created client" do
    now = now()
    _user_1 = insert!(:user, inserted_at: DateTime.add(now, 1, :second))
    user_2 = insert!(:user, inserted_at: DateTime.add(now, 2, :second))

    assert Loader.last() == user_2
  end

  test "count/0 returns count of users" do
    insert!(:user)
    insert!(:user)

    assert Loader.count() == 2
  end

  test "count_by/0 returns count of users matching given clauses" do
    insert!(:user, name: "John")
    insert!(:user, name: "John")
    insert!(:user, name: "Jane")

    assert Loader.count_by(name: "John") == 2
  end
end
