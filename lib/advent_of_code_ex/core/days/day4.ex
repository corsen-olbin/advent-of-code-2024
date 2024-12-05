defmodule AdventOfCodeEx.Core.Days.Day4 do
  alias AdventOfCodeEx.Core.Helpers.Map2D

  def part_1(input) do
    input
    |> Map2D.read_input_as_map_2d
    |> find_xmases
  end

  def part_2(input) do
    input
    |> Map2D.read_input_as_map_2d
    |> find_x_mases
  end

  # part 1
  def find_xmases(map) do
    Enum.reduce(map, 0, fn {x, v}, acc ->
      Enum.reduce(v, acc, fn {y, v2}, acc2 -> acc2 + xmas_count(map, x, y, v2) end)
    end)
  end

  def xmas_count(map, x, y, value) do
    case value do
      "X" -> check_around(map, {x, y})
      _ -> 0
    end
  end

  def directions() do
    [
      {-1, -1},
      {-1,  0},
      {-1,  1},
      { 0, -1},
      { 0,  1},
      { 1, -1},
      { 1,  0},
      { 1,  1}
    ]
  end

  def check_around(map, coords) do
    directions()
    |> Enum.count(fn direc -> check_direction(map, coords, direc) end)
  end

  def check_direction(map, {x, y}, {xc, yc}) do
    check_direction_rec(["M", "A", "S"], map, {x + xc, y + yc}, {xc, yc})
  end

  def check_direction_rec([], _, _, _), do: true
  def check_direction_rec([letter | letters], map, {x, y}, {xc, yc}) do
    if letter == Map2D.get(map, x, y) do
      check_direction_rec(letters, map, {x + xc, y + yc}, {xc, yc})
    else
      false
    end
  end

  # part 2
  def find_x_mases(map) do
    Enum.reduce(map, 0, fn {x, v}, acc ->
      Enum.reduce(v, acc, fn {y, v2}, acc2 -> acc2 + is_x_mas(map, x, y, v2) end)
    end)
  end

  def is_x_mas(map, x, y, v) do
    case v do
      "A" -> if(is_x_mas?(map, x, y), do: 1, else: 0)
      _ -> 0
    end
  end

  def is_x_mas?(map, x, y) do
    topleft = Map2D.get(map, x - 1, y - 1)
    topright = Map2D.get(map, x - 1, y + 1)
    bottomleft = Map2D.get(map, x + 1, y - 1)
    bottomright = Map2D.get(map, x + 1, y + 1)
    cross1 = "#{topleft}A#{bottomright}"
    cross2 = "#{topright}A#{bottomleft}"

    (cross1 == "MAS" or cross1 == "SAM")
    and (cross2 == "MAS" or cross2 == "SAM")
  end
end
