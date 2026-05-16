defmodule Raccoon do
  require ExFuzzywuzzy

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
    # :erlang.phash2()
    row
    |> Map.values()
    |> Enum.sort()
    |> Enum.join("|")
  end

  def fuzz(l, r) do
    round(ExFuzzywuzzy.Similarity.Levenshtein.calculate(l, r) * 100)
  end

  def max_by_score(xs) do
    xs |> Enum.max_by(fn {_, _, s} -> s end)
  end

  # ON^2
  # Performance improve: Select and remove the exactly match using hash(left) == hash(right) to skip fuzz computation
  def reconciliate(left_set, right_set) do
    norm_left_content = for {id, content} <- left_set, do: {id, content |> normalize |> hash}
    norm_right_content = for {id, content} <- right_set, do: {id, content |> normalize |> hash}

    pared_with_scores =
      for {l_id, l_content} <- norm_left_content,
          {r_id, r_content} <- norm_right_content,
          do: {l_id, r_id, fuzz(l_content, r_content)}

    grouped_by_left = pared_with_scores |> Enum.group_by(fn {l, _, _} -> l end)
    highest_score = for {_, xs} <- grouped_by_left, do: max_by_score(xs)
    highest_score |> Enum.group_by(fn {_, _, s} -> s end, fn {l, r, _} -> {l, r} end)
  end
end
