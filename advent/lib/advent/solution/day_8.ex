defmodule Advent.Solution.Day8 do

  def part_one do
    rows = get_problem_input

    Enum.reduce(Enum.with_index(rows), 0, fn {row, row_index}, all_visible_trees ->
      visible_trees_in_row = Enum.reduce(Enum.with_index(row), 0, fn {tree, tree_index}, visible_trees ->
        left = Enum.take(row, tree_index)
        right = Enum.take(row, tree_index + 1 - length(row))
        top = Enum.take(rows, row_index) |> Enum.map(fn row -> Enum.at(row, tree_index) end)
        bottom = Enum.take(rows, row_index + 1 - length(rows)) |> Enum.map(fn row -> Enum.at(row, tree_index) end)


        cond do
          # this can probably be simplified by getting lengths of the sightlines; a 0 length will be an edge?
          row_index == 0 || tree_index == 0 || row_index == length(rows) - 1 || tree_index == length(row) - 1 ->
            visible_trees + 1
          true ->
            visible_paths = Enum.filter([left, right, top, bottom], fn dir ->
              shorter_trees = Enum.filter(dir, fn t -> t < tree end)
              # IO.puts "#{tree} > #{inspect(Enum.sort(shorter_trees))}"
              length(shorter_trees) == length(dir)
            end)

            if length(visible_paths) > 0 do
              visible_trees + 1
            else
              visible_trees
            end
        end
      end)

      all_visible_trees + visible_trees_in_row
    end)
  end

  ###

  def part_two do
    rows = get_problem_input

    Enum.map(Enum.with_index(rows), fn {row, row_index} ->
      Enum.map(Enum.with_index(row), fn {tree, tree_index} ->
        left = Enum.take(row, tree_index)
        right = Enum.take(row, tree_index + 1 - length(row))
        top = Enum.take(rows, row_index) |> Enum.map(fn row -> Enum.at(row, tree_index) end)
        bottom = Enum.take(rows, row_index + 1 - length(rows)) |> Enum.map(fn row -> Enum.at(row, tree_index) end)

        Enum.reduce([Enum.reverse(left), right, Enum.reverse(top), bottom], 1, fn dir, dir_scenic_score ->
          viewable_trees = Enum.take_while(dir, fn t -> t < tree end)

          lingering_visible = List.first(Enum.take(dir, length(viewable_trees) - length(dir)))

          if is_integer(lingering_visible) && lingering_visible >= tree do
            # when not an edge, count the tree that broke the sightline
            (length(viewable_trees) + 1) * dir_scenic_score
          else
            # captures the 0 from the edges
            length(viewable_trees) * dir_scenic_score
          end
        end)
      end)
    end)
    |> List.flatten
    |> Enum.max

  end

  ###

  defp parse_response_body(body) do
    body
    |> String.trim_trailing
    |> String.split("\n", trim: true)
    |> Enum.map(fn s ->
      String.split(s, "", trim: true)
      |> Enum.map(fn n -> # nested loop is not great but this is fast enough for part 1
        String.to_integer(n)
      end)
    end)
  end

  defp get_problem_input do
    Advent.InputFetcher.fetch_for_day(8, &parse_response_body/1)
  end
end
