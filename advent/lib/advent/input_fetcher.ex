defmodule Advent.InputFetcher do
  def fetch_for_day(day_num, parser_fn) do
    session_id = System.get_env("ADVENT_SESSION_ID")
    uri = "https://adventofcode.com/2022/day/#{day_num}/input"
    headers = %{ 'Cookie' => "session=#{session_id}" }

    case HTTPoison.get(uri, headers) do
      {:ok, %{status_code: 200, body: body}} -> parser_fn.(body)
      # {:error, %{reason: reason}} -> reason
      # not dealing with error cases since these are all one-offs
    end
  end
end
