defmodule AdventOfCodeEx.Core.Days.Day2 do

  def part_1(input) do
    input
    |> read_input
    |> num_of_safe_lists(&is_safe/1)
  end

  def part_2(input) do
    input
    |> read_input
    |> num_of_safe_lists(&is_safe_2/1)
  end

  def read_input(input) do
    input
    |> String.split("\r\n")
    |> Enum.map(fn x -> String.split(x, " ") |> Enum.map(&String.to_integer/1) end)
  end

  def num_of_safe_lists(lists, is_safe) do
    lists
    |> Enum.count(is_safe)
  end

  def is_safe(list) do
    diffs =
    list
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [x1, x2] -> x1 - x2 end)

    (Enum.all?(diffs, &(&1 < 0)) or Enum.all?(diffs, &(&1 > 0)))
    and Enum.all?(diffs, &(-4 < &1 and &1 < 4))
  end

  def is_safe_2(list) do
    is_safe_2_rec(list, list, 0, Enum.count(list))
  end

  def is_safe_2_rec(orig_list, list, index, count) do
    cond do
      is_safe(list) -> true
      index >= count -> false
      true -> is_safe_2_rec(orig_list, List.delete_at(orig_list, index), index + 1, count)
    end
  end
end
