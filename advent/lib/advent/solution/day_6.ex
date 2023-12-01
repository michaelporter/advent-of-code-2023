defmodule Advent.Solution.Day6 do

  def part_one do
    get_problem_input
    |> find_uniq_chunk(4, 0)
  end

  defp find_uniq_chunk(data, chunk_size, count_from_start) do
    chunk = Enum.take(data, chunk_size)

    if length(Enum.uniq(chunk)) == chunk_size do
      count_from_start + chunk_size
    else
      {_, chopped} = Enum.split(data, 1)
      find_uniq_chunk(chopped, chunk_size, count_from_start + 1)
    end
  end

  ###

  def part_two do
    get_problem_input
    |> find_uniq_chunk(14, 0)
  end

  ###


  defp parse_response_body(body) do
    body
    |> String.trim_trailing
    |> String.split("", trim: true)
  end

  defp get_problem_input do
    Advent.InputFetcher.fetch_for_day(6, &parse_response_body/1)
  end
end
