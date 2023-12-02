defmodule Advent.Solution.Day2 do

  # each game, its a random number of cubes of different colors
  # a few times each game, elf takes out a random number of cubes and shows them to me

  # Game X: num1 col1, num2 col2; num2 col2, num2 col1, num2 col3 ...

  # based on the outcomes, which games would have been possible if
  # the bag held 12 Red, 13 Green, and 14 Blue

  # the answer to part 1 is the sum of the IDs of the games that would have been possible

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

  # what is the fewest number of cubes of each color that would
  # make each game possible?
  # the answer is the sum of each game's 'power', or the min color counts multiplied together

  def part_two do
    #get_problem_input()

  end


  ###

  defp parse_response_body(body) do
    # body = "Game 3: 5 red, 9 blue, 1 green; 5 red; 11 red, 2 green, 8 blue; 2 green, 6 blue\nGame 4: 2 red, 5 green; 2 blue, 3 red, 3 green; 3 red, 2 blue; 8 green, 2 red"
    String.trim_trailing(body)
    # |> String.split("\n\n")
    |> String.split("\n", trim: true)
    |> Enum.map(fn game ->
      [game_string, cubes] = String.split(game, ": ")

      [_, game_num] = String.split(game_string, " ")

      handfuls = String.split(cubes, "; ")
      |> Enum.map(fn handful ->
        # "5 red, 9 blue, 1 green"
        String.split(handful, ", ")
        |> Enum.reduce(%{}, fn h, color_counts ->
          [num_str, color] = String.split(h, " ")
          key = String.to_atom(color)
          Map.put(color_counts, key, String.to_integer(num_str))
        end)
      end)

      %{ game: String.to_integer(game_num), handfuls: handfuls }
    end)

  end

  defp get_problem_input do
    Advent.InputFetcher.fetch_for_day(2, &parse_response_body/1)
  end

end
