defmodule Cronex.Parser do
  @moduledoc """
  This modules is responsible for time parsing.
  """

  @days_of_week [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday]

  @doc """
  Parses a given `frequency` and `time` to a tuple.

  ## Example

      iex> Cronex.Parser.parse_regular_frequency(:hour)
      {0, :*, :*, :*, :*}

      iex> Cronex.Parser.parse_regular_frequency(:day, "10:00")
      {0, 10, :*, :*, :*}

      iex> Cronex.Parser.parse_regular_frequency(:day, "12:10")
      {10, 12, :*, :*, :*}

      iex> Cronex.Parser.parse_regular_frequency(:wednesday, "12:00")
      {0, 12, :*, :*, 3}

      iex> Cronex.Parser.parse_regular_frequency(:non_existing_day)
      :invalid

      iex> Cronex.Parser.parse_regular_frequency(:monday, "invalid time")
      :invalid
  """
  def parse_regular_frequency(frequency, time \\ "00:00") do
    parsed_time = parse_time(time)
    do_parse_regular_frequency(frequency, parsed_time)
  end

  defp do_parse_regular_frequency(_, :invalid), do: :invalid

  defp do_parse_regular_frequency(frequency, {hour, minute}) do
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

      true ->
        :invalid
    end
  end

  @doc """
  Parses a given `interval`, `frequency` and `time` to a tuple.

  `interval` is a function wich receives one argument and returns the remainder of the division of that argument by the given `interval` 

  ## Example

      iex> Cronex.Parser.parse_interval_frequency(2, :hour)
      {0, interval, :*, :*, :*}

      iex> Cronex.Parser.parse_interval_frequency(2, :invalid_day)
      :invalid
  """
  def parse_interval_frequency(interval, frequency, time \\ "00:00") do
    parsed_time = parse_time(time)
    do_parse_interval_frequency(interval, frequency, parsed_time)
  end

  defp do_parse_interval_frequency(_, _, :invalid), do: :invalid

  defp do_parse_interval_frequency(interval, frequency, {hour, minute}) do
    interval_fn = fn arg -> rem(arg, interval) end

    cond do
      frequency == :minute ->
        {interval_fn, :*, :*, :*, :*}

      frequency == :hour ->
        {0, interval_fn, :*, :*, :*}

      frequency == :day ->
        {minute, hour, interval_fn, :*, :*}

      frequency == :month ->
        {minute, hour, 1, interval_fn, :*}

      true ->
        :invalid
    end
  end

  defp parse_time(time) when is_bitstring(time) do
    try do
      time
      |> String.split(":")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    rescue
      _ -> :invalid
    end
  end
end
