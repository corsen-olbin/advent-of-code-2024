defmodule AdventOfCodeEx.Core.Helpers.Map2D do
  def get(map, row_key, column_key) do
    case Map.get(map, row_key) do
      nil -> nil
      x -> Map.get(x, column_key)
    end
  end

  def put(map, row_key, column_key, value) do
    Map.update(map, row_key, %{column_key => value}, fn inner_map ->
      Map.put(inner_map, column_key, value)
    end)
  end

  def update(map, row_key, column_key, default, func) do
    Map.update(map, row_key, %{column_key => default}, fn inner_map ->
      Map.update(inner_map, column_key, default, func)
    end)
  end

  def delete(map, {row_key, column_key}) do
    new_map =
      Map.update(
        map,
        row_key,
        %{},
        fn x -> Map.delete(x, column_key) end
      )

    # clean up row if it's empty
    if map_size(Map.get(new_map, row_key)) == 0 do
      Map.delete(new_map, row_key)
    else
      new_map
    end
  end

  def count(map, func?) do
    Enum.reduce(map, 0, fn {_x, v}, acc ->
      Enum.reduce(v, acc, fn {_y, v2}, acc2 -> if func?.(v2), do: acc2 + 1, else: acc2 end)
    end)
  end

  def find_index(map, func?) do
    Enum.find_value(map, 0, fn {x, v} ->
      Enum.find_value(v, fn {y, v2} -> if func?.(v2), do: {x, y}, else: false end)
    end)
  end

  def find_all_indices(map, func?) do
    Enum.reduce(map, [], fn {x, v}, acc ->
      Enum.reduce(v, acc, fn {y, v2}, acc2 -> if func?.(v2), do: [{x ,y} | acc2], else: acc2 end)
    end)
  end

  def read_input_as_map_2d(input) do
    input
    |> String.split
    |> add_lines_to_map
  end

  def add_lines_to_map(lines) do
    add_to_map_rec(%{}, lines, 0)
  end

  defp add_to_map_rec(acc, [], _x), do: acc

  defp add_to_map_rec(acc, [line | lines], x) do
    line
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce(acc, fn {v, i}, a -> put(a, x, i, v) end)
    |> add_to_map_rec(lines, x + 1)
  end

  def inspect(map) do
    Enum.each(map, fn {_, x} ->
      Enum.each(x, fn {_, y} -> IO.write(y) end)
      IO.puts("")
    end)
    IO.puts("")
  end
end
