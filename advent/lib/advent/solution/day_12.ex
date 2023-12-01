defmodule Advent.Solution.Day12 do

  # the input is a grid of topographical data
  #
  # the heights are represented by lowercase letters, with
  # 'a' being the lowest, and 'z' being the highest height
  #
  # my current position is marked as 'S', and the location
  # that should get the best signal is marked 'E'
  #
  # 'S' is an 'a', and 'E' is a 'z'
  #
  # i want to get from 'S' to 'E' in as few steps as possible.
  # on each step I can move 1 square up, down, left, or right.
  #
  # the elevation of my next position can be at most 1 level higher than
  # my current one, but it can also be any amount lower

  def part_one do
    grid = get_problem_input

    starting_pos = get_terminal_coords(grid, "S")
    ending_pos = get_terminal_coords(grid, "E")

  end

  defp letters do
    (?a..?z)
      |> Enum.to_list
      |> List.to_string
      |> String.split("", trim: true)
  end

  defp letter_map do
    letters()
      |> Enum.with_index
      |> Enum.into(%{}, fn ({letter, index}) -> {letter, index} end)
  end

  defp get_terminal_coords(grid, identifier) do
    { _, reg} = Regex.compile(identifier)

    {_, pos_y} = grid
      |> Enum.with_index
      |> Enum.find(fn {row, index} -> String.match?(row, reg) end)

    {_, pos_x} = grid
      |> Enum.at(pos_y)
      |> String.split("", trim: true)
      |> Enum.with_index
      |> Enum.find(fn {col, index} -> col == identifier end)

    { pos_x, pos_y }
  end

  def part_two do
  end

  ###

  defp parse_response_body(body) do
    body

    "Sabqponm
    abcryxxl
    accszExk
    acctuvwj
    abdefghi"
    |> String.trim_trailing
    |> String.split("\n", trim: true)
    |> Enum.map(fn row -> String.trim_leading(row) end)
  end


  # I didn't parse the input this time; there is no honor here
  defp get_problem_input do
    Advent.InputFetcher.fetch_for_day(12, &parse_response_body/1)
  end
end
