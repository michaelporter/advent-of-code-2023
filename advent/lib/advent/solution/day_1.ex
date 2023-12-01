defmodule Advent.Solution.Day1 do

  def part_one do
    elf_backpacks = get_problem_input

    Enum.reduce(elf_backpacks, 0, fn elf_backpack, last_highest ->
      Enum.reduce(elf_backpack, 0, fn item, calories -> item + calories end)
      |> highest_one(last_highest)
    end)
  end

  defp highest_one(first, second) do
    Enum.sort([first, second]) |> List.last
  end

  ###

  def part_two do
    elf_backpacks = get_problem_input

    Enum.reduce(elf_backpacks, [], fn elf_backpack, top_three ->
      Enum.reduce(elf_backpack, 0, fn item, calories -> item + calories end)
      |> highest_three(top_three)
    end)
    |> Enum.reduce(fn elf, total -> elf + total end)
  end

  defp highest_three(contender, current_set \\ []) do
    case current_set do
      [a, b, c] -> [contender | current_set] |> Enum.sort |> Enum.slice(1, 3)
      _ -> [contender | current_set]
    end
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
