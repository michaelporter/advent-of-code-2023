defmodule Advent.Solution.Day1 do

  def part_one do

  end


  ###

  def part_two do

  end


  ###

  defp parse_response_body(body) do
    String.trim_trailing(body)
    |> String.split("\n\n")
    |> Enum.map(fn elf ->
      String.split(elf, "\n")
      |> Enum.map(fn item -> String.to_integer(item) end)
    end)
  end

  defp get_problem_input do
    Advent.InputFetcher.fetch_for_day(1, &parse_response_body/1)
  end

end
