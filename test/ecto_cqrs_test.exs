defmodule EctoCQRSTest do
  use ExUnit.Case
  doctest EctoCQRS

  test "greets the world" do
    assert EctoCQRS.hello() == :world
  end
end
