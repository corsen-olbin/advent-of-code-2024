defmodule AdventOfCodeEx.Core.Days.Day6 do
  alias AdventOfCodeEx.Core.Helpers.Map2D

  def part_1(input) do
    input
    |> Map2D.read_input_as_map_2d
    |> move_guard
    |> Map2D.count(fn x -> x == "X" end)
  end

  def part_2(input) do
    input
    |> Map2D.read_input_as_map_2d
    #|> move_guard_part_2(:map)
    |> move_guard_part_2(:blocks)
    |> Enum.count
  end

  def move_guard(map) do
    guard_pos = Map2D.find_index(map, fn x -> x == "^" end)

    move_guard_rec(map, :up, guard_pos)
  end

  def move_guard_rec(map, direction, guard_pos = {x, y}) do
    {new_x, new_y} = calc_new_position(direction, guard_pos)

    case Map2D.get(map, new_x, new_y) do
      nil -> Map2D.put(map, x, y, "X")
      "#" ->
        new_direc = calc_new_direction(direction)
        move_guard_rec(Map2D.put(map, x, y, "X"), new_direc, calc_new_position(new_direc, guard_pos))
      _ -> move_guard_rec(Map2D.put(map, x, y, "X"), direction, {new_x, new_y})
    end
  end

  def calc_new_direction(direction) do
    case direction do
      :up -> :right
      :right -> :down
      :down -> :left
      :left -> :up
    end
  end

  def calc_new_position(direction, {x, y}) do
    case direction do
      :up -> {x - 1, y}
      :down -> {x + 1, y}
      :right -> {x, y + 1}
      :left -> {x, y - 1}
    end
  end

  def move_guard_part_2(map, return) do
    guard_pos = Map2D.find_index(map, fn x -> x == "^" end)
    IO.inspect(guard_pos, label: "Guard pos")

    move_guard_part2_rec(map, [], :up, guard_pos, return)
  end

  def move_guard_part2_rec(map, blocks, direction, guard_pos = {x, y}, return) do
    {new_x, new_y} = calc_new_position(direction, guard_pos)

    new_direc = calc_new_direction(direction)

    case Map2D.get(map, new_x, new_y) do
      nil -> if return == :blocks, do: blocks, else: map
      "#" ->
        move_guard_part2_rec(Map2D.put(map, x, y, "+"), blocks, new_direc, calc_new_position(new_direc, guard_pos), return)
      _ ->
        new_blocks = if stuck_in_loop?(map, guard_pos, new_direc), do: [{new_x, new_y} | blocks], else: blocks
        move_guard_part2_rec(update_map(map, x, y, direction), new_blocks, direction, {new_x, new_y}, return)
    end
  end

  def update_map(map, x, y, direction) do
    new_symbol = case Map2D.get(map, x, y) do
      "^" -> "^"
      "-" -> if direction == :up or direction == :down, do: "+", else: "-"
      "|" -> if direction == :right or direction == :left, do: "+", else: "|"

      "+" -> "+"
      _ -> if direction == :right or direction == :left, do: "-", else: "|"
    end

    Map2D.put(map, x, y, new_symbol)
  end

  def stuck_in_loop?(map, init_pos, direc) do
    stuck_in_loop_rec(map, init_pos, direc)
  end

  def stuck_in_loop_rec(map, pos, direc) do
    # #IO.write(direc)
    # #IO.inspect(pos)
    # {for_x, for_y} = calc_new_position(direc, pos)
    # {next_direc, {next_x, next_y}} = case Map2D.get(map, for_x, for_y) do
    #   "#" ->
    #     new_direc = calc_new_direction(direc)
    #     {new_direc, calc_new_position(new_direc, pos)}
    #   _ -> {direc, calc_new_position(direc, pos)}
    # end

    # cond do
    #   is_nil(Map2D.get(map, next_x, next_y)) -> false
    #   init_pos == {next_x, next_y} and init_direc == next_direc -> true
    #   true -> stuck_in_loop_rec(map, init_pos, init_direc, {next_x, next_y}, next_direc)
    # end

    {next_x, next_y} = calc_new_position(direc, pos)
    symbol = Map2D.get(map, next_x, next_y)
    cond do
      is_nil(symbol) or symbol == "#" -> false
      symbol == "+" -> true
        # {nnx, nny} = calc_new_position(direc, {next_x, next_y})
        # Map2D.get(map, nnx, nny) == "#"
      # symbol == "-" and (direc == :right or direc == :left) -> stuck_in_loop_rec(map, {next_x, next_y}, direc)
      # symbol == "|" and (direc == :up or direc == :down) -> stuck_in_loop_rec(map, {next_x, next_y}, direc)
      true -> stuck_in_loop_rec(map, {next_x, next_y}, direc)
    end
  end
end
