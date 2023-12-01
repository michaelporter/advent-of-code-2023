defmodule Advent.Solution.Day11 do

  # I'd like to consolidate these such that I can pass in the "worry adjustment"
  # function. Would need to curry to allow for different inputs?
  #
  # Right now I'm a week behind on AoC problems, so I'm not going to fine-tune this just yet.

  def part_one do
    monkeys = get_problem_input

    iterations = Enum.to_list (0..19)

    Enum.reduce(iterations, monkeys, fn (iteration, monkey_state) ->
      monkeys
      |> Enum.with_index
      |> Enum.reduce(monkey_state, fn ({_, current_index}, monkey_state) ->
        current_monkey = Enum.at(monkey_state, current_index)

        %{
          items: items,
          operation: operation,
          test: test,
          true_destination: true_destination,
          false_destination: false_destination,
          inspections: inspections
        } = current_monkey

        monkey_moves = Enum.into(monkeys, [], fn _ -> [] end)

        monkey_moves = Enum.reduce(items, monkey_moves, fn(item, monkey_moves) ->
          upon_inspection = operation.(item)
          unharmed_object = (upon_inspection / 3)
          |> Float.to_string
          |> String.split(".")
          |> List.first
          |> String.to_integer

          dest_monkey_index = if test.(unharmed_object), do: true_destination, else: false_destination

          List.update_at(monkey_moves, dest_monkey_index, fn monk -> monk ++ [unharmed_object] end)
        end)

        monkey_state = List.update_at(monkey_state, current_index, fn monk ->
          Map.replace(monk, :inspections, monk[:inspections] + length(items))
        end)

        monkey_state = List.update_at(monkey_state, current_index, fn monk ->
          Map.replace(monk, :items, [])
        end)

        monkey_moves
        |> Enum.with_index
        |> Enum.reduce(monkey_state, fn({monkey_move, monkey_index}, state) ->

          List.update_at(state, monkey_index, fn monk ->
            current_items = monk[:items]
            Map.replace(monk, :items, current_items ++ monkey_move)
          end)
        end)
      end)
    end)
    |> Enum.map(fn r -> r[:inspections] end)
    |> Enum.sort
    |> Enum.take(-2)
    |> Enum.reduce(1, fn(monk, prod) -> monk * prod end)
  end

  ###

  def part_two do
    # thanks to this explanation!
    # https://tranzystorek-io.github.io/paste/#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
    monkeys = get_problem_input

    iterations = Enum.to_list (0..9999)
    all_divisors = Enum.reduce(monkeys, 1, fn monk, p -> monk[:divisor] * p end)

    Enum.reduce(iterations, monkeys, fn (iteration, monkey_state) ->
      monkeys
      |> Enum.with_index
      |> Enum.reduce(monkey_state, fn ({_, current_index}, monkey_state) ->
        current_monkey = Enum.at(monkey_state, current_index)

        %{
          items: items,
          operation: operation,
          test: test,
          true_destination: true_destination,
          false_destination: false_destination,
          inspections: inspections
        } = current_monkey

        monkey_moves = Enum.into(monkeys, [], fn _ -> [] end)

        monkey_moves = Enum.reduce(items, monkey_moves, fn(item, monkey_moves) ->
          unharmed_object = operation.(item) |> rem(all_divisors)

          dest_monkey_index = if test.(unharmed_object), do: true_destination, else: false_destination

          List.update_at(monkey_moves, dest_monkey_index, fn monk -> monk ++ [unharmed_object] end)
        end)

        monkey_state = List.update_at(monkey_state, current_index, fn monk ->
          Map.replace(monk, :inspections, monk[:inspections] + length(items))
        end)

        monkey_state = List.update_at(monkey_state, current_index, fn monk ->
          Map.replace(monk, :items, [])
        end)

        monkey_moves
        |> Enum.with_index
        |> Enum.reduce(monkey_state, fn({monkey_move, monkey_index}, state) ->

          List.update_at(state, monkey_index, fn monk ->
            current_items = monk[:items]
            Map.replace(monk, :items, current_items ++ monkey_move)
          end)
        end)
      end)
    end)
    |> Enum.map(fn r -> r[:inspections] end)
    |> Enum.sort
    |> Enum.take(-2)
    |> Enum.reduce(1, fn(monk, prod) -> monk * prod end)
  end

  ###
  defp parse_response_body do
    [
      %{
        items: [98, 70, 75, 80, 84, 89, 55, 98],
        operation: &(&1 * 2),
        test: &(rem(&1, 11) == 0),
        divisor: 11,
        true_destination: 1,
        false_destination: 4,
        inspections: 0
      },
      %{
        items: [59],
        operation: &(&1 * &1),
        test: &(rem(&1, 19) == 0),
        divisor: 19,
        true_destination: 7,
        false_destination: 3,
        inspections: 0
      },
      %{
        items: [77, 95, 54, 65, 89],
        operation: &(&1 + 6),
        test: &(rem(&1, 7) == 0),
        divisor: 7,
        true_destination: 0,
        false_destination: 5,
        inspections: 0
      },
      %{
        items: [71, 64, 75],
        operation: &(&1 + 2),
        test: &(rem(&1, 17) == 0),
        divisor: 17,
        true_destination: 6,
        false_destination: 2,
        inspections: 0
      },
      %{
        items: [74, 55, 87, 98],
        operation: &(&1 * 11),
        test: &(rem(&1, 3) == 0),
        divisor: 3,
        true_destination: 1,
        false_destination: 7,
        inspections: 0
      },
      %{
        items: [90, 98, 85, 52, 91, 60],
        operation: &(&1 + 7),
        test: &(rem(&1, 5) == 0),
        divisor: 5,
        true_destination: 0,
        false_destination: 4,
        inspections: 0
      },
      %{
        items: [99, 51],
        operation: &(&1 + 1),
        test: &(rem(&1, 13) == 0),
        divisor: 13,
        true_destination: 5,
        false_destination: 2,
        inspections: 0
      },
      %{
        items: [98, 94, 59, 76, 51, 65, 75],
        operation: &(&1 + 5),
        test: &(rem(&1, 2) == 0),
        divisor: 2,
        true_destination: 3,
        false_destination: 6,
        inspections: 0
      }
    ]
  end

  # I didn't parse the input this time; there is no honor here
  defp get_problem_input do
    # Advent.InputFetcher.fetch_for_day(11, &parse_response_body/1)
    "Monkey 0:
    Starting items: 98, 70, 75, 80, 84, 89, 55, 98
    Operation: new = old * 2
    Test: divisible by 11
      If true: throw to monkey 1
      If false: throw to monkey 4

  Monkey 1:
    Starting items: 59
    Operation: new = old * old
    Test: divisible by 19
      If true: throw to monkey 7
      If false: throw to monkey 3

  Monkey 2:
    Starting items: 77, 95, 54, 65, 89
    Operation: new = old + 6
    Test: divisible by 7
      If true: throw to monkey 0
      If false: throw to monkey 5

  Monkey 3:
    Starting items: 71, 64, 75
    Operation: new = old + 2
    Test: divisible by 17
      If true: throw to monkey 6
      If false: throw to monkey 2

  Monkey 4:
    Starting items: 74, 55, 87, 98
    Operation: new = old * 11
    Test: divisible by 3
      If true: throw to monkey 1
      If false: throw to monkey 7

  Monkey 5:
    Starting items: 90, 98, 85, 52, 91, 60
    Operation: new = old + 7
    Test: divisible by 5
      If true: throw to monkey 0
      If false: throw to monkey 4

  Monkey 6:
    Starting items: 99, 51
    Operation: new = old + 1
    Test: divisible by 13
      If true: throw to monkey 5
      If false: throw to monkey 2

  Monkey 7:
    Starting items: 98, 94, 59, 76, 51, 65, 75
    Operation: new = old + 5
    Test: divisible by 2
      If true: throw to monkey 3
      If false: throw to monkey 6"


    parse_response_body
  end
end
