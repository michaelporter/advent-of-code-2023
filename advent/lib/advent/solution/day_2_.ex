defmodule Advent.Solution.Day2 do

  def part_one do
    max_colors = %{ red: 12, green: 13, blue: 14}

    get_problem_input()
    |> Enum.filter(fn game ->
      Enum.all?(game.handfuls, fn handful ->
        Enum.all?(handful, fn {color, num} ->
          num <= Map.get(max_colors, color)
        end)
      end)
    end)
    |> Enum.reduce(0, &(&1.game + &2))
  end

  ###

  def part_two do
    Advent.InputFetcher.fetch_for_day(2, &alt_parse_response_body/1)
    |> Enum.reduce(%{}, fn row, game_minimum_colors ->
      current_mins = game_minimum_colors[row.game_num]
      trimmed_row = Map.drop(row, [:game_num])

      if current_mins do
        Map.put(game_minimum_colors, row.game_num, Map.merge(current_mins, trimmed_row, fn _, old, new ->
          if old > new, do: old, else: new
        end))
      else
        Map.put_new(game_minimum_colors, row.game_num, trimmed_row)
      end
    end)
    |> Enum.reduce(0, fn {_, color_minimums}, total_power ->
      Map.values(color_minimums)
      |> Enum.reduce(1, &(&1 * &2))
      |> Kernel.+(total_power)
    end)
  end

  ###

  defp parse_response_body(body) do
    String.trim_trailing(body)
    |> String.split("\n", trim: true)
    |> Enum.map(fn game ->
      [game_string, cubes] = String.split(game, ": ")
      [_, game_num] = String.split(game_string, " ")

      handfuls = String.split(cubes, "; ")
      |> Enum.map(fn handful ->
        String.split(handful, ", ")
        |> Enum.reduce(%{}, fn h, color_counts ->
          [num_str, color] = String.split(h, " ")
          key = String.to_atom(color)
          Map.put(color_counts, key, String.to_integer(num_str))
        end)
      end)

      %{ game: String.to_integer(game_num), handfuls: handfuls, input: game }
    end)
  end

  defp alt_parse_response_body(body) do
    String.trim_trailing(body)
    |> String.split("\n", trim: true)
    |> extract_game_data
  end

  defp extract_game_data(rows) do
    Enum.reduce(rows, [], fn game, listed_handfuls ->
      [game_string, cubes] = String.split(game, ": ")
      [_, game_num] = String.split(game_string, " ")

      String.split(cubes, "; ")
      |> Enum.map(fn handful ->
        String.split(handful, ", ")
        |> Enum.reduce(%{}, fn h, color_counts ->
          [num_str, color] = String.split(h, " ")
          Map.put_new(color_counts, String.to_atom(color), String.to_integer(num_str))
        end)
        |> Map.put_new(:game_num, String.to_integer(game_num))
      end)
      |> Kernel.++(listed_handfuls)
    end)
  end

  defp get_problem_input do
    Advent.InputFetcher.fetch_for_day(2, &parse_response_body/1)
  end

end
