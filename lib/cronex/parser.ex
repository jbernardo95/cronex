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
  """
  def parse_frequency(frequency, time \\ "00:00") do
    {hour, minute} = parse_time(time)

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
    end
  end

  defp parse_time(time) when is_bitstring(time) do
    time 
    |> String.split(":")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple
  end
end
