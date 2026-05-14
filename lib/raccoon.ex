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

  def reconciliate(left_set, right_set) do
    hash_left_set =
      left_set
      |> Map.new(fn {i, s} -> {s |> normalize |> hash, i} end)

    hash_right_set =
      right_set
      |> Map.new(fn {i, s} -> {s |> normalize |> hash, i} end)

    reconciliated =
      Map.intersect(hash_left_set, hash_right_set, fn _, l, r -> {l, r} end)
      |> Map.values()
      |> Map.new()

    [%{100 => reconciliated}]
  end

  # ON^2
  def reconciliate_fuzz(left_set, right_set) do
    norm_left_set =
      left_set
      |> Map.new(fn {i, s} -> {i, s |> normalize |> hash} end)

    norm_right_set =
      right_set
      |> Map.new(fn {i, s} -> {i, s |> normalize |> hash} end)

    # make combination
    all_possible_pairs = for l <- norm_left_set, r <- norm_right_set, do: {l, r}
    IO.inspect(pairs: all_possible_pairs)
    # group by first index
    grouped = all_possible_pairs |> Enum.group_by(fn {{l, _}, _} -> l end)
    IO.inspect(grouped: grouped)

    scores =
      grouped
      |> Map.new(fn {li, lrs} ->
        {li,
         lrs
         |> Enum.map(fn {{_, lb}, {ri, rb}} ->
           {ri, round(ExFuzzywuzzy.Similarity.Levenshtein.calculate(lb, rb) * 100)}
         end)}
      end)

    IO.inspect(scores: scores)
    # order scores values by second element of tuble

    # tranforme to left index => maximun element in values (first tuple)

    ## ExFuzzywuzzy.ratio(norm_left_set, norm_right_set)
  end
end
