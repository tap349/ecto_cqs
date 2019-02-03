defmodule EctoCQRS.Factory do
  def build(:user) do
    %EctoCQRS.User{name: "foo", email: "foo@example.com"}
  end

  def build(factory_name, attrs) when is_map(attrs) or is_list(attrs) do
    factory_name |> build() |> struct(attrs)
  end

  def insert!(factory_name, attrs \\ []) do
    factory_name |> build(attrs) |> EctoCQRS.Repo.insert!()
  end
end
