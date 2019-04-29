defmodule EctoCQS.SchemaHelpersTest do
  use EctoCQS.DataCase
  alias EctoCQS.User

  test "cast/2" do
    attrs = %{name: "John", email: "john@example.com", age: "32"}

    assert User.cast(attrs) == %{
             name: "John",
             email: "john@example.com",
             age: 32
           }
  end
end
