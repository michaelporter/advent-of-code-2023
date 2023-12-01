defmodule Advent.Solution.Day4 do

  def part_one do
    Enum.reduce(get_problem_input, 0, fn assignment_pair, overlapping ->
      [assignment1, assignment2] = assignment_pair

      cond do
        Enum.empty?(assignment1 -- assignment2) ->
          overlapping = overlapping + 1
        Enum.empty?(assignment2 -- assignment1) ->
          overlapping = overlapping + 1
        true ->
          overlapping
      end
    end)
  end

  ###

  def part_two do
    Enum.reduce(get_problem_input, 0, fn assignment_pair, overlapping ->
      [assignment1, assignment2] = assignment_pair

      cond do
        length(assignment1 -- assignment2) < length(assignment1) ->
          overlapping = overlapping + 1
        length(assignment2 -- assignment1) < length(assignment2) ->
          overlapping = overlapping + 1
        true ->
          overlapping
      end
    end)
  end

  ###

  defp parse_response_body(body) do
    body
    |> String.trim_trailing
    |> String.split("\n")
    |> Enum.map(fn pair -> String.split(pair, ",") end)
    |> Enum.map(fn pair ->
      Enum.map(pair, fn p ->
        String.split(p, "-") |> Enum.map(fn num -> String.to_integer(num) end)
      end)
    end)
    |> Enum.map(fn pair ->
      [[start1, end1],[start2, end2]] = pair
      [
        Enum.to_list(start1..end1),
        Enum.to_list(start2..end2)
      ]
    end)
  end

  defp get_problem_input do
    Advent.InputFetcher.fetch_for_day(4, &parse_response_body/1)
  end
end
