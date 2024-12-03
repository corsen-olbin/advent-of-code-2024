defmodule AdventOfCodeEx.Core.Days.Day1 do


  def part_1(input) do
    input
    |> read_input()
    |> calc_day_1()
  end

  def part_2(input) do
    input
    |> read_input()
    |> calc_day_2()
  end

  def read_input(input) do
    input
    |> String.split("\r\n")
    |> Enum.map(fn x -> String.split(x, "   ") end)
    |> Enum.reduce({[], []}, fn [x1, x2], {acc1, acc2} -> {[String.to_integer(x1) | acc1], [String.to_integer(x2) | acc2] } end)
  end

  def calc_day_1({list1, list2}) do
    ord1 = Enum.sort(list1)
    ord2 = Enum.sort(list2)

    Enum.zip_reduce(ord1, ord2, 0, fn x1, x2, acc -> acc + abs(x1 - x2) end)
  end

  def calc_day_2({leftl, rightl}) do
    leftl
    |> Enum.reduce(0, fn elem, acc -> acc + (elem * Enum.count(rightl, &(&1 == elem))) end)
  end
end
