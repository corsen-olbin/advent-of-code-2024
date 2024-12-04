defmodule AdventOfCodeEx.Core.Days.Day3 do


  def part_1(input) do
    input
    |> read_input
    |> Enum.reduce(0, fn {x1, x2}, acc -> acc + (x1 * x2) end)
  end

  def part_2(input) do
    input
    |> read_input_2()
    |> Enum.reduce(0, fn {x1, x2}, acc -> acc + (x1 * x2) end)
  end

  def read_input(input) do
    Regex.scan(~r/mul\(([0-9]+),([0-9]+)\)/, input, capture: :all)
    |> Enum.map(fn [_, x1, x2] -> { String.to_integer(x1), String.to_integer(x2) } end)
  end

  def read_input_2(input) do
    Regex.scan(~r/mul\(([0-9]+),([0-9]+)\)|do\(\)|don't\(\)/, input, capture: :all)
    |> read_input_2_rec([], :do)
  end

  def read_input_2_rec([], dos, _dodont), do: dos
  def read_input_2_rec([x | xs], dos, dodont) do
    case x do
      ["do()"] -> read_input_2_rec(xs, dos, :do)
      ["don't()"] -> read_input_2_rec(xs, dos, :dont)
      [_, x1, x2] -> read_input_2_rec(xs, if(dodont == :do, do: [{String.to_integer(x1), String.to_integer(x2)} | dos], else: dos), dodont)
    end
  end
end
