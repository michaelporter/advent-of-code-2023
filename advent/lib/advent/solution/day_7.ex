defmodule Advent.Solution.Day7 do

  # we are trying to find file space to clean up
  #
  # first ask is to find all directories whose size adds up to <= 100,000
  #
  # then, we get the sum of the sizes of these directories.
  #
  # the instructions also say we are expected to count files more than once
  #

  def part_one do
    # my strategy, I think:
    # build the file tree as a data structure, then recursively iterate over it to get the counts
    { sys, dir_sizes } = get_problem_input
    |> build_file_system(["/"], %{"/" => %{}}, %{"/" => []})
    # |> print_directory

    sum_of_small_dirs = dir_sizes |> get_dir_sizes_below(100000)
    |> Enum.reduce(0, fn dir, sum ->
      dir_size = Enum.reduce(dir_sizes[dir], 0, &(&1 + &2))
      # IO.puts inspect Enum.join(dir, " ") <> " " <> inspect dir_size
      sum + dir_size #Enum.reduce(dir_sizes[dir], 0, &(&1 + &2))
    end)

    sum_of_small_dirs
  end

  def part_two do
    size_to_free_up = 2080344

    { sys, dir_sizes } = get_problem_input |> build_file_system(["/"], %{"/" => %{}}, %{"/" => []})

    result = dir_sizes |> get_dir_sizes_below(1000000000) # lol, no refactoring tonight
    |> Enum.filter(fn dir ->
      dir_size = Enum.reduce(dir_sizes[dir], 0, &(&1 + &2))
      dir_size >= size_to_free_up
    end)
    |> Enum.map(fn dir -> Enum.reduce(dir_sizes[dir], 0, &(&1 + &2)) end)
    |> Enum.sort |> List.first

  end

  defp get_dir_sizes_below(dir_sizes, max) do
    IO.puts inspect dir_sizes
    dirs = Map.keys(dir_sizes)
    |> Enum.filter(fn dir -> Enum.reduce(dir_sizes[dir], 0, &(&1 + &2)) <= max end)

    IO.puts "DIRS BELOW"
    IO.puts inspect dirs

    dirs
  end


  defp get_all_dir_names(sys) do
    sys
    |> Map.keys
    |> Enum.filter(fn k -> Regex.match?(~r/^[[:alpha:]]+|\/$/, k) && !is_integer(sys[k]) end)
    |> Enum.flat_map(fn k -> IO.puts(k); [k | get_all_dir_names(sys[k])] end)
  end

  #defp calculate_dir_sizes(sys, current_path, sizes) do
  # end

  # do directory names occur multiple times throughout the file system?
  defp calculate_dir_sizes(sys) do


    sys
    |> Map.keys
    |> Enum.reduce(0, fn k, size ->
      # IO.puts k
      if is_integer(sys[k]) do
        size + sys[k]
      else
        size + calculate_dir_sizes(sys[k])
      end
    end)

    # Enum.reduce(0, fn k, size ->
    #   if is_integer(sys[k]) do
    #     size + sys[k]
    #   else
    #     size + calculate_dir_sizes(sys[k], k)
    #   end
    # end)

    # IO.puts current_path <> " " <> "#{inspect size}"
    # IO.puts "-"


    # |> Map.keys
    # |> Enum.map(fn k -> if is_integer(sys[k]), do:  , else: calculate_dir_sizes(sys[k], indent + 1, sizes)) end)

    # |> result
  end

  defp print_directory(sys, indent \\ 0) do
    padding = Enum.into((0..indent), [], fn i -> " " end) |> Enum.join()

    # yikes!
    sys
    |> Map.keys
    |> Enum.each(fn k -> if is_integer(sys[k]), do: IO.puts(padding <> inspect(sys[k]) <> " " <> k), else: (IO.puts(padding <> k); print_directory(sys[k], indent + 2)) end)
  end

  defp build_file_system([], _current_path, tree, dir_sizes) do
    { tree, dir_sizes }
  end

  defp build_file_system(cmds, current_path, tree, dir_sizes) do
    [cmd | rest] = cmds

    # IO.puts inspect cmd
    # IO.puts inspect rest

    # currently:
    # I think I have all the "$ cd" lines figured
    # next would be the "$ ls", which should populate child keys with
    # both files and directories
    # then comes the summing of file sizes and associating that with directories

    cond do
      Regex.match?(~r/^\$ cd \.\./, cmd) ->
        # IO.puts "in CD .."
        # [_, c, dest_dir] = String.split(cmd, " ")

        # current_dir = get_in(tree, current_path)
        {new_path, _} = Enum.split(current_path, length(current_path) - 1)
        build_file_system(rest, new_path, tree, dir_sizes)

      Regex.match?(~r/^\$ cd \//, cmd) ->
        if !Map.has_key?(tree, "/") do
          Map.put tree, "/", %{}
        end

        # if !Map.has_key?(dir_sizes, ["/"]) do
        #   dir_sizes = Map.put dir_sizes, ["/"], [0]
        # end

        build_file_system(rest, ["/"], tree, dir_sizes)

      Regex.match?(~r/^\$ cd/, cmd) ->
        [_, _c, dest_dir] = String.split(cmd, " ", trim: true)

        current_dir = get_in(tree, current_path)

        if Map.has_key?(current_dir, dest_dir) do
          # navigate to it
          build_file_system(rest, current_path ++ [dest_dir], tree, dir_sizes)
        else
          # add directory, navigate to it
          {_, updated_tree} = get_and_update_in(tree, current_path, fn val -> {
            val,
            Map.put(val, dest_dir, %{})
          } end)

          IO.puts "already exists?"
          IO.puts Map.has_key?(dir_sizes, current_path ++ [dest_dir])
          IO.puts " "

          updated_dir_sizes = Map.put(dir_sizes, current_path ++ [dest_dir], [0])

          build_file_system(rest, current_path ++ [dest_dir], updated_tree, updated_dir_sizes)
        end

      cmd == "$ ls" ->
        # handle the ls case
        # - basically just recurse again, and let the next run catch the "dir" or "1223 file.sdf" cases,
        #   which should add themselves to the current directory
        build_file_system(rest, current_path, tree, dir_sizes)

      Regex.match?(~r/^dir /, cmd) ->
        [_, dest_dir] = String.split(cmd, " ")

        current_dir = get_in(tree, current_path)

        if Map.has_key?(current_dir, dest_dir) do
          # continue
          build_file_system(rest, current_path, tree, dir_sizes)
        else
          # add directory, DON'T navigate to it
          {_, updated_tree} = get_and_update_in(tree, current_path, fn val -> {
            val,
            Map.put(val, dest_dir, %{})
          } end)

          updated_dir_sizes = Map.put(dir_sizes, current_path ++ [dest_dir], [0])

          build_file_system(rest, current_path, updated_tree, updated_dir_sizes)
        end

      Regex.match?(~r/^[[:digit:]]+ [[:alpha:]]+\.?[[:alpha:]]{0,3}/, cmd) ->
        [filesize, filename] = String.split(cmd, " ")

        current_dir = get_in(tree, current_path)

        # add file to current directory, points to size value
        if Map.has_key?(current_dir, filename) do
          # continue
          build_file_system(rest, current_path, tree, dir_sizes)
        else
          {_, updated_tree} = get_and_update_in(tree, current_path, fn val -> {
            val,
            Map.put(val, filename, String.to_integer(filesize))
          } end)

          updated_dir_sizes = add_filesize_to_all_dirs(dir_sizes, current_path, filesize)

          build_file_system(rest, current_path, updated_tree, updated_dir_sizes)
        end
    end
  end

  defp add_missing_key(dir_sizes, current_path) do
    if !Map.has_key?(dir_sizes, current_path) do
      Map.put(dir_sizes, current_path, [0])
    else
      dir_sizes
    end
  end

  defp add_filesize_to_all_dirs(dir_sizes, [], filesize) do
    dir_sizes
  end

  defp add_filesize_to_all_dirs(dir_sizes, current_path, filesize) do
    dir_sizes = add_missing_key(dir_sizes, current_path)
    IO.puts inspect(dir_sizes)
    IO.puts inspect(current_path)
    IO.puts inspect(dir_sizes[current_path])
    {_, updated_dir_sizes} = get_and_update_in(dir_sizes, [current_path], fn val ->
      IO.puts "val: #{inspect val}"
      {
      val,
      val ++ [String.to_integer filesize]
    } end)

    remaining_path = Enum.take(current_path, length(current_path) - 1)

    add_filesize_to_all_dirs(updated_dir_sizes, remaining_path, filesize)
  end




  ###

  defp parse_response_body(body) do
    body
    |> String.trim_trailing
    |> String.split("\n", trim: true)
    # |> Enum.filter(fn row -> Regex.match?(~r/^[[:digit:]]/, row) end)
  end

  defp get_problem_input do
    Advent.InputFetcher.fetch_for_day(7, &parse_response_body/1)
  end
end
