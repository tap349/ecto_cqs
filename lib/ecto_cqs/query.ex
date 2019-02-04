defmodule EctoCQS.Query do
  import Ecto.Query, except: [limit: 2, order_by: 2], warn: false

  def by(query, clauses) do
    query |> where(^clauses)
  end

  def order_by(query, expr) do
    query |> Ecto.Query.order_by(^expr)
  end

  def random(query) do
    query |> Ecto.Query.order_by(fragment("RANDOM()"))
  end

  def first(query) do
    query |> first(:inserted_at)
  end

  def last(query) do
    query |> last(:inserted_at)
  end

  def limit(query, limit) do
    query |> Ecto.Query.limit(^limit)
  end
end
