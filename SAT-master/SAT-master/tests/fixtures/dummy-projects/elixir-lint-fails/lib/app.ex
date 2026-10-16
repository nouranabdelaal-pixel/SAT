defmodule App do
  def add(a, b) do
    IO.inspect(a)
    a + b
  end

  def twice(a), do: a * 2
end
