defmodule Advent.Solution.Day1 do

  def part_one do
    [
      0 | get_problem_input()
    ]
    |> Enum.reduce(fn row, sum ->
      digits = Regex.scan(~r/\d/, row)

      calibration_number = Enum.join([
        Enum.at(digits, 0),
        Enum.at(digits, -1)
      ]) |> String.to_integer()

      sum + calibration_number
    end)
  end


  ###

  # this doesn't get the eight out of  "oneight"
  # but tbh I'm not sure if I need to get the text ones out just yet
  #parsed = Regex.scan(~r/one|two|three|four|five|six|seven|eight|nine|\d/U, calibration_string)
  def part_two do

  end


  ###

  defp parse_response_body(body) do
    String.trim_trailing(body)
    # |> String.split("\n\n")
    |> String.split("\n", trim: true)

  end

  defp get_problem_input do
    Advent.InputFetcher.fetch_for_day(1, &parse_response_body/1)
  end

end
