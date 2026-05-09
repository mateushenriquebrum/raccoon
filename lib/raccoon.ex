defmodule Raccoon do
  @moduledoc """
  Documentation for `Raccoon`.
  """

  def normalize(row) do
    row
    |> Map.map(fn {_, value} -> String.upcase(value) end)
  end
end
