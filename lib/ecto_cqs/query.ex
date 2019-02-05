# don't wrap simple queries like Ecto.Query.order_by/3
# or Ecto.Query.limit/3 - use them in Loader directly
defmodule EctoCQS.Query do
  import Ecto.Query, warn: false

  def random(query) do
    query |> Ecto.Query.order_by(fragment("RANDOM()"))
  end

  def first(query) do
    query |> first(:inserted_at)
  end

  def last(query) do
    query |> last(:inserted_at)
  end
end
