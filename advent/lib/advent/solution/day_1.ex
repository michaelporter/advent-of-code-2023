defmodule Advent.Solution.Day1 do

  def part_one do
    get_problem_input()
    |> Enum.reduce(0, fn row, sum ->
      digits = Regex.scan(~r/\d/, row)

      calibration_number = Enum.join([
        Enum.at(digits, 0),
        Enum.at(digits, -1)
      ]) |> String.to_integer()

      sum + calibration_number
    end)
  end

  ###

  def part_two do
    get_problem_input()
    |> Enum.reduce(0, fn calibration_string, sum ->
      calibration_number = extract_word_digits(calibration_string)
      |> extract_literal_digits(calibration_string)
      |> Enum.sort(&sort_by_index/2)
      |> get_calibration_number

      sum + calibration_number
    end)
  end


  ###

  defp get_calibration_number(digits) do
    {first, _} = Enum.at(digits, 0)
    {last, _} = Enum.at(digits, -1)

    "#{first}#{last}" |> String.to_integer()
  end

  defp extract_literal_digits(digits, calibration_string) do
    literal_digits = Regex.scan(~r/\d/, calibration_string, return: :index)

    Enum.reduce(literal_digits, digits, fn literal_digit, d ->
      [{index, _}] = literal_digit
      parsed_digit = String.at(calibration_string, index)

      [{parsed_digit, index} | d]
    end)
  end

  defp extract_word_digits(calibration_string) do
    number_words = [
      "one",
      "two",
      "three",
      "four",
      "five",
      "six",
      "seven",
      "eight",
      "nine"
    ]

    Enum.reduce(number_words, [], fn number_word, digits ->
      matches = Regex.scan(~r/(#{number_word})/, calibration_string, return: :index)

      Enum.reduce(matches, digits, fn [{index, _}, _], acc ->
        [{number_word_int_str(number_word), index} | acc ]
      end)
    end)
  end

  defp number_word_int_str(number_word) do
    case number_word do
      "one" -> "1"
      "two" -> "2"
      "three" -> "3"
      "four" -> "4"
      "five" -> "5"
      "six" -> "6"
      "seven" -> "7"
      "eight" -> "8"
      "nine" -> "9"
    end
  end

  defp sort_by_index(a, b) do
    {_, index_a} = a
    {_, index_b} = b

    index_a < index_b
  end

  defp parse_response_body(body) do
    String.trim_trailing(body)
    # |> String.split("\n\n")
    |> String.split("\n", trim: true)

  end

  defp get_problem_input do
    Advent.InputFetcher.fetch_for_day(1, &parse_response_body/1)
  end

end
