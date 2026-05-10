defmodule Raccoon do
  @moduledoc """
  Documentation for `Raccoon`.
  """

  @spec normalize(map()) :: map()
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

  @spec hash(map()) :: String.t()
  def hash(row) do
    row
    |> Map.values()
    |> Enum.sort()
    |> Enum.join("|")
  end

  def match(left, right) do
    if hash(normalize(left)) == hash(normalize(right)) do
      %{:hash => 100}
    else
      %{:hash => 0}
    end
  end
end
