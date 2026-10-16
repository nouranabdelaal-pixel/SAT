defmodule AppTest do
  use ExUnit.Case, async: true

  test "adds" do
    assert App.add(1, 2) == 3
  end

  test "doubles" do
    assert App.twice(2) == 4
  end
end
