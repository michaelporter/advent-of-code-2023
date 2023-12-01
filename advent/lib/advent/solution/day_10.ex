defmodule Advent.Solution.Day10 do

  def part_one do
    %{ history: history } = get_problem_input()
    |> Enum.reduce(%{last: {"noop", 0}, history: []}, &read_clock_cycles/2)

    results = history |> Enum.reverse

    [20, 60, 100, 140, 180, 220]
    |> Enum.map(fn i -> i * Enum.at(results, i - 1) end)
    |> Enum.sum
  end

  defp read_clock_cycles({action, current_x_change}, ticker) do
    %{last: {_, last_x_change}, history: history} = ticker

    %{
      last: {action, current_x_change},
      history: update_history(history, action, last_x_change)
    }
  end

  defp update_history(history, action, x_change) do
    base_x = if length(history) == 0, do: 1, else: Enum.at(history, 0)
    current_x_value = x_change + base_x

    case action do
      "noop" ->
        new_history = [current_x_value]
        List.flatten([new_history | history])

      "addx" ->
        new_history = [current_x_value, current_x_value]
        List.flatten([new_history | history])
      _ -> history
    end
  end

  ###

  def part_two do
    %{ history: history } = get_problem_input()
    |> Enum.reduce(%{last: {"noop", 0}, history: []}, &read_clock_cycles/2)

    history
    |> Enum.reverse
    |> Enum.with_index
    |> Enum.reduce(build_screen(), &print_screen/2)

  end

  defp print_screen({cursor_position, index}, screen) when cursor_position < 0 do
    print_screen({40 + cursor_position, index}, screen)
  end

  defp print_screen({cursor_position, index}, screen) do
    crt_row_index = get_value_row(index)
    crt_col_index = index - 40 * crt_row_index

    if is_overlap?(cursor_position, crt_col_index) do
      update_screen(screen, crt_row_index, crt_col_index)
    else
      screen
    end
  end

  defp build_screen do
    Enum.into(0..5, [], fn _ -> Enum.into(0..39, [], fn _ -> "." end) end)
  end

  defp is_overlap?(cursor_col_index, crt_col_index) do
    cond do
      Enum.member?([cursor_col_index - 1, cursor_col_index, cursor_col_index + 1], crt_col_index) ->
        true
      cursor_col_index == 39 && crt_col_index == 0 ->
        true
      true ->
        false
    end
  end

  defp update_screen(screen, row, col) do
    updated_row = Enum.at(screen, row)
    |> List.update_at(col, fn _ -> "#" end)

     List.update_at(screen, row, fn _ -> updated_row end)
  end

  defp get_value_row(index) do
    cond do
      index < 40 -> 0
      index > 39 && index < 80 -> 1
      index > 79 && index < 120 -> 2
      index > 119 && index < 160 -> 3
      index > 159 && index < 200 -> 4
      index > 199 && index < 240 -> 5
    end
  end

  ###

  defp parse_response_body(body) do
    String.trim_trailing(body)
    |> String.split("\n", trim: true)
    |> Enum.map(fn cmd -> String.split(cmd, " ", trim: true) end)
    |> Enum.map(fn cmd ->
      cmd = if length(cmd) == 2, do: [Enum.at(cmd, 0), String.to_integer(Enum.at(cmd, 1))], else: [Enum.at(cmd, 0), 0]
      List.to_tuple(cmd)
    end)
  end

  defp get_problem_input do
    Advent.InputFetcher.fetch_for_day(10, &parse_response_body/1)
  end
end
