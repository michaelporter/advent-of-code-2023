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
    |> Enum.reduce(0, fn game, sum ->
      sum + game.game
    end)
  end

  ###

  def part_two do
    get_problem_input()
    |> Enum.reduce(0, fn game, pow_sum ->
      game_power = Enum.reduce(game.handfuls, %{red: 0, green: 0, blue: 0}, fn handful, min_colors ->
        local_min = Enum.reduce(handful, %{red: 0, green: 0, blue: 0 }, fn {color, count}, local_min_colors ->
          if count > local_min_colors[color] do
            Map.put(local_min_colors, color, count)
          end
        end)
        |> Enum.into(%{})

        Enum.map(local_min, fn {color, count} ->
          if count > min_colors[color] do
            {color, count}
          else
            {color, min_colors[color]}
          end
        end) |> Enum.into(%{})
      end)
      |> Enum.reduce(1, fn {_, count}, pow ->
         count * pow
      end)

      pow_sum + game_power
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

  defp get_problem_input do
    Advent.InputFetcher.fetch_for_day(2, &parse_response_body/1)
  end

end
