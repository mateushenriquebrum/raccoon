defmodule Raccoon do
  @moduledoc """
  Documentation for `Raccoon`.
  """

  def normalize(row) do
    row
    # upper case everything
    |> Map.new(fn {k, v} -> {k, String.upcase(v)} end)
    # remove R$ currency
    |> Map.new(fn {k, v} -> {k, Regex.replace(~r/R\$/i, v, "")} end)
    # remove € currency
    |> Map.new(fn {k, v} -> {k, Regex.replace(~r/€/i, v, "")} end)
    # remove $ currency
    |> Map.new(fn {k, v} -> {k, Regex.replace(~r/\$/i, v, "")} end)
    # float point with 2 digits
    |> Map.new(fn {k, v} -> {k, Regex.replace(~r/\.([0-9])$/i, v, ".\\g{1}0")} end)
    # float point with 2 digits
    |> Map.new(fn {k, v} -> {k, Regex.replace(~r/,([0-9])$/i, v, ",\\g{1}0")} end)
  end
end
