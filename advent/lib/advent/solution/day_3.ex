defmodule Advent.Solution.Day3 do

  def part_one do
    knapsacks =  Enum.map(get_problem_input(), fn knap ->
      str_length = String.length(knap)
      [
        String.slice(knap, 0, div(str_length, 2)),
        String.slice(knap, div(str_length, 2), str_length)
      ]
    end)
    points_map = get_points_map()

    Enum.map(knapsacks, fn(knap) ->
      [first, second] = knap
      ["" | f] = String.split(first, "")

      letter = Enum.find(f, fn (letter) -> String.contains?(second, letter) end)
      points_map[letter]
    end)
    |> Enum.reduce(0, fn num, total -> num + total end)
  end

  defp get_points_map do
    ["" | letters] = (
      ?a..?z |> Enum.to_list |> List.to_string
    ) <> (
      ?A..?Z |> Enum.to_list |> List.to_string
    ) |> String.split("")

    letters
    |> Enum.with_index
    |> Enum.into(%{}, fn ({k,v}) -> {k, v + 1} end )
  end

  ###

  def part_two do
    knapsacks = get_problem_input()
    points_map = get_points_map()

    Enum.chunk_every(knapsacks, 3)
    |> Enum.reduce(0, fn elf_group, points_total ->
      [first_elf | rest] = elf_group
      ["" | first_elf] = String.split(first_elf, "")

      letter = Enum.find(first_elf, fn letter ->
        Enum.all?(rest, fn (elf) ->
          String.contains?(elf, letter)
        end)
      end)

      points_map[letter] + points_total
    end)
  end

  ###

  defp parse_response_body(body) do
    body |> String.trim_trailing |> String.split("\n")
  end

  defp get_problem_input do
    Advent.InputFetcher.fetch_for_day(3, &parse_response_body/1)
  end
end
