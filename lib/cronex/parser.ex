defmodule Cronex.Parser do
  @moduledoc"""
  This modules is responsible for time parsing.
  """

  @days_of_week [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday]

  @doc """
  Parses a given frequency and time to a tuple.

  ## Example

      iex> Cronex.Parser.parse_frequency(:hour)
      {0, :*, :*, :*, :*}

      iex> Cronex.Parser.parse_frequency(:day, "10:00")
      {0, 10, :*, :*, :*}

      iex> Cronex.Parser.parse_frequency(:day, "12:10")
      {10, 12, :*, :*, :*}

      iex> Cronex.Parser.parse_frequency(:wednesday, "12:00")
      {0, 12, :*, :*, 3}

      iex> Cronex.Parser.parse_frequency(:non_existing_day)
      :invalid

      iex> Cronex.Parser.parse_frequency(:monday, "invalid time")
      :invalid
  """
  def parse_frequency(frequency, time \\ "00:00") do
    parsed_time = parse_time(time)
    do_parse_frequency(frequency, parsed_time)
  end
         
  defp do_parse_frequency(_, :invalid), do: :invalid
  defp do_parse_frequency(frequency, {hour, minute}) do
    cond do
      frequency == :minute ->
        {:*, :*, :*, :*, :*}

      frequency == :hour ->
        {0, :*, :*, :*, :*}

      frequency == :day ->
        {minute, hour, :*, :*, :*}

      frequency == :month ->
        {minute, hour, 1, :*, :*}

      frequency == :year ->
        {minute, hour, 1, 1, :*}

      frequency in @days_of_week ->
        day_of_week = Enum.find_index(@days_of_week, &(&1 == frequency)) + 1
        {minute, hour, :*, :*, day_of_week}

      true -> :invalid 
    end
  end

  defp parse_time(time) when is_bitstring(time) do
    try do
      time 
      |> String.split(":")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple
    rescue
      _ -> :invalid
    end
  end
end
