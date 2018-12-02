defmodule ExAdventTest do
  use ExUnit.Case
  doctest ExAdvent

  test "greets the world" do
    assert ExAdvent.hello() == :world
  end
end
