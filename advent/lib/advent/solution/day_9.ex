defmodule Advent.Solution.Day9 do

  def part_one do
    moves = get_problem_input()

    %{starting_pos: starting_pos, grid: grid } = build_grid(moves)

    # can probably use the same function as part 2 -- get one that
    grid = traverse_grid(moves, grid, %{head: starting_pos, tail: starting_pos})

    count = List.flatten(grid)
    |> Enum.filter(fn pos -> pos == "X" end)
    |> length

    { grid, count }
  end

  defp traverse_grid([], grid, current_pos) do
    grid
  end

  # can probably use the same function as part 2 -- get one that
  defp traverse_grid([{direction, move_count} | moves], grid, current_pos) do
    %{head: head_pos, tail: tail_pos} = current_pos

    positions_during_move = %{head: [head_pos], tail: [tail_pos]}

    all_positions_hit_during_move = Enum.reduce(1..move_count, positions_during_move, fn step, pdm ->
      %{
        head: [ {latest_head_x, latest_head_y} | _ ],
        tail: [ latest_tail | _ ]
      } = pdm

      case direction do
        :R ->
          new_head = { latest_head_x + 1, latest_head_y }
          new_tail = get_new_tail(latest_tail, new_head)
          %{ head: [new_head | pdm[:head]], tail: [new_tail | pdm[:tail]] }
        :L ->
          new_head = { latest_head_x - 1, latest_head_y }
          new_tail = get_new_tail(latest_tail, new_head)
          %{ head: [new_head | pdm[:head]], tail: [new_tail | pdm[:tail]] }
        :U ->
          new_head = { latest_head_x, latest_head_y + 1 }
          new_tail = get_new_tail(latest_tail, new_head)
          %{ head: [new_head | pdm[:head]], tail: [new_tail | pdm[:tail]] }
        :D ->
          new_head = { latest_head_x, latest_head_y - 1 }
          new_tail = get_new_tail(latest_tail, new_head)
          %{ head: [new_head | pdm[:head]], tail: [new_tail | pdm[:tail]] }
        true ->
          IO.puts "bad things have happened"
      end
    end)

    %{ head: [updated_head | rest_head], tail: [updated_tail | rest_tail] } = all_positions_hit_during_move

    grid = update_grid_with_touched_coords(grid, [updated_tail | rest_tail])

    traverse_grid(moves, grid, %{head: updated_head, tail: updated_tail})
  end

  defp update_grid_with_touched_coords(grid, positions_hit) do
    positions_hit
    |> Enum.uniq
    |> Enum.reverse
    |> Enum.with_index
    |> Enum.reduce(grid, fn (pos_p, g) ->
      {pos, pos_index} = pos_p

      {tail_x, tail_y} = pos
      row = Enum.at(g, tail_y)
      row = List.update_at(row, tail_x, fn val -> "X" end)
      List.update_at(g, tail_y, fn val -> row end)
    end)
  end

  defp get_new_tail(current_tail_pos, leader_pos) do
    differences = Enum.zip_reduce(
      Tuple.to_list(current_tail_pos),
      Tuple.to_list(leader_pos),
      [],
      fn t, h, acc ->
        [h - t | acc]
    end) |> Enum.reverse

    calc_tail(differences, current_tail_pos)
  end

  ###

  def part_two do
    moves = get_problem_input()

    %{starting_pos: starting_pos, grid: grid } = build_grid(moves)
    tail_pos = Enum.into(0..8, [], fn _ -> [starting_pos] end)

    head_path = head_travel(moves, starting_pos)
    final_tail_path = get_new_tail_2(tail_pos, [Enum.reverse(head_path)])

    grid = update_grid_with_touched_coords(grid, final_tail_path)

    count = List.flatten(grid)
    |> Enum.filter(fn pos -> pos == "X" end)
    |> length

    { grid, count }
  end

  defp get_new_tail_2(tails, collected_paths)

  defp get_new_tail_2([], [ final_tail | _ ]) do
    final_tail
  end

  defp get_new_tail_2([current_knot | remaining_knots], collected_paths) do
    [ current_knot_pos | _ ] = current_knot
    [ leader_path | _ ] = collected_paths # the most recent path

    current_knot_path = Enum.reduce(leader_path, [current_knot_pos], fn leader_step, knot_moves ->
      [latest_knot_pos | _ ] = knot_moves

      differences = Enum.zip_reduce(
        Tuple.to_list(latest_knot_pos),
        Tuple.to_list(leader_step),
        [],
        fn t, h, acc ->
          [h - t | acc]
      end) |> Enum.reverse

      new_pos = calc_tail(differences, latest_knot_pos)

      if length(collected_paths) == 8 do
        IO.puts "Leader POS: #{inspect leader_step}, Knot Move: #{inspect(latest_knot_pos)} -> #{inspect(new_pos)}"
      end

      [new_pos | knot_moves]
    end)

    get_new_tail_2(remaining_knots, [Enum.reverse(current_knot_path) | collected_paths])
  end

  defp head_travel(direction, current_pos, head_moves \\ [])

  defp head_travel([], current_pos, head_moves) do
    head_moves
  end

  defp head_travel([{direction, move_count} | remaining_moves], current_pos, head_moves) do
    positions_during_move = [current_pos]

    all_positions_hit_during_move = Enum.reduce(1..move_count, positions_during_move, fn step, pdm ->
      [{latest_head_x, latest_head_y} | _] = pdm

      case direction do
        :R ->
          new_head = { latest_head_x + 1, latest_head_y }
          [new_head | pdm]
        :L ->
          new_head = { latest_head_x - 1, latest_head_y }
          [new_head | pdm]
        :U ->
          new_head = { latest_head_x, latest_head_y + 1 }
          [new_head | pdm]
        :D ->
          new_head = { latest_head_x, latest_head_y - 1 }
          [new_head | pdm]
        true ->
          IO.puts "bad things have happened"
      end
    end)

    [final_pos | _] = all_positions_hit_during_move

    head_travel(remaining_moves, final_pos, List.flatten([all_positions_hit_during_move | head_moves]))
  end

  defp calc_tail(differences, current_tail_pos) do
    differences_abs = Enum.map(differences, fn d -> abs(d) end)

    cond do
      [0, 0] == differences_abs ->
        current_tail_pos
      Enum.member?([[0, 1], [1, 0], [1, 1]], differences_abs) ->
        current_tail_pos
      true -> # handle all distances
        Enum.zip_reduce(Tuple.to_list(current_tail_pos), differences, [], fn t, d, acc ->
          if d == 0 do
            [t | acc]
          else
            pos_change = if d > 0, do: 1, else: -1
            [t + pos_change | acc]
          end
        end)
        |> Enum.reverse
        |> List.to_tuple
    end

  end

  ###

  defp build_grid(moves, grid_dimensions \\ {200, 200}, current_pos \\ {0,0}, starting_pos \\ {0, 0})

  defp build_grid([], {grid_width, grid_height}, final_pos, starting_pos) do
    IO.puts "width - height: " <> Integer.to_string(grid_width) <> " - " <> Integer.to_string(grid_height)
    %{
      starting_pos: starting_pos,
      grid: Enum.into(0..grid_height, [], fn (_) -> Enum.reduce(0..grid_width, [], fn _, rr -> rr ++ [0] end) end)
    }
  end

  defp build_grid(moves, grid_dimensions, current_pos, starting_pos) do
    [current_move | remaining_moves] = moves
    { grid_width, grid_height } = grid_dimensions
    { pos_x, pos_y } = current_pos
    { starting_x, starting_y } = starting_pos

    case current_move do
      {:R, x_moves} ->
        new_pos_x = pos_x + x_moves
        new_grid_width = if new_pos_x > grid_width, do: new_pos_x, else: grid_width

        build_grid(remaining_moves, {new_grid_width, grid_height}, {new_pos_x, pos_y}, starting_pos)
      {:L, x_moves} ->
        new_pos_x = pos_x - x_moves
        new_grid_width = if new_pos_x < 0, do: grid_width - new_pos_x, else: grid_width
        new_starting_x = if new_pos_x < 0, do: starting_x + new_grid_width - grid_width, else: starting_x
        new_pos_x = if new_pos_x < 0, do: 0, else: new_pos_x

        build_grid(remaining_moves, {new_grid_width, grid_height}, {new_pos_x, pos_y}, {new_starting_x, starting_y})
      {:U, y_moves} ->
        new_pos_y = pos_y + y_moves
        new_grid_height = if new_pos_y > grid_height, do: new_pos_y, else: grid_height

        build_grid(remaining_moves, {grid_width, new_grid_height}, {pos_x, new_pos_y}, starting_pos)
      {:D, y_moves} ->
        new_pos_y = pos_y - y_moves # - 7
        new_grid_height = if new_pos_y < 0, do: grid_height - new_pos_y, else: grid_height
        new_starting_y = if new_pos_y < 0, do: starting_y + new_grid_height - grid_height, else: starting_y
        new_pos_y = if new_pos_y < 0, do: 0, else: new_pos_y

        build_grid(remaining_moves, {grid_width, new_grid_height}, {pos_x, new_pos_y}, {starting_x, new_starting_y})
    end
  end

  ###

  defp parse_response_body(body) do
    _ = [:R, :U, :L, :D]
    body
    |> String.trim_trailing
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.split(line, " ", trim: true) end) # |> List.to_tuple end)
    |> Enum.map(fn head_instruction ->
      [direction, count] = head_instruction
      {String.to_existing_atom(direction), String.to_integer(count)}
    end)

    # produces a list of tuples, {Direction, Count (as a string)}

  end

  defp get_problem_input do
    Advent.InputFetcher.fetch_for_day(9, &parse_response_body/1)
  end


end
