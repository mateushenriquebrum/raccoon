defmodule Raccoon do
  @moduledoc """
  Documentation for `Raccoon`.
  """

  def normalize(row) do
    row
    |> Map.new(fn {k, v} -> {k, String.upcase(v)} end)
    |> Map.new(fn {k, v} -> {k, Regex.replace(~r/R\$/i, v, "")} end)
    |> Map.new(fn {k, v} -> {k, Regex.replace(~r/€/i, v, "")} end)
    |> Map.new(fn {k, v} -> {k, Regex.replace(~r/\$/i, v, "")} end)
  end
end
