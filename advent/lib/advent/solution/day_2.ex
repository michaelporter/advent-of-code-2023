defmodule Advent.Solution.Day2 do

  def part_one do
    get_problem_input |> Enum.reduce(0, fn (moves, total_score) ->
      [opp, me] = moves
      outcome_values[get_outcome(opp, me)] + move_values[me] + total_score
    end)
  end

  defp get_outcome(opp, me) do
    case [opp, me] do
      ["A", "X"] -> :draw
      ["A", "Y"] -> :win
      ["A", "Z"] -> :lose
      ["B", "X"] -> :lose
      ["B", "Y"] -> :draw
      ["B", "Z"] -> :win
      ["C", "X"] -> :win
      ["C", "Y"] -> :lose
      ["C", "Z"] -> :draw
    end
  end

  defp move_values do
    %{ "X" => 1, "Y" => 2, "Z" => 3 }
  end

  defp outcome_values do
    %{ lose: 0, draw: 3, win: 6 }
  end

  defp instructed_outcome do
    %{ "X" => :lose, "Y" => :draw, "Z" => :win}
  end

  ###

  def part_two do
    get_problem_input |> Enum.reduce(0, fn (moves, total_score) ->
      [opp, _] = moves
      my_move = get_my_move(moves)
      outcome_values[get_outcome(opp, my_move)] + move_values[my_move] + total_score
    end)
  end

  defp get_my_move([opp, my_instruction]) do
    outcome_states = outcome_states_for_opp_move(opp)
    instruction = instructed_outcome[my_instruction]

    outcome_states[instruction]
  end

  defp outcome_states_for_opp_move(opp) do
    case opp do
      "A" -> %{ win: "Y", lose: "Z", draw: "X"}
      "B" -> %{ win: "Z", lose: "X", draw: "Y"}
      "C" -> %{ win: "X", lose: "Y", draw: "Z"}
    end
  end

  ###

  defp parse_response_body(body) do  # [["A", "Y"], ["B", "X"], ...]
    body |> String.trim_trailing |> String.split("\n") |> Enum.map(fn pair -> String.split(pair, " ") end)
  end

  defp get_problem_input do
    Advent.InputFetcher.fetch_for_day(2, &parse_response_body/1)
  end
end
