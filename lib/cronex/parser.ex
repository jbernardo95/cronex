defmodule Cronex.Parser do
  @moduledoc"""
  This modules is responsible for time parsing.
  """

  @doc """
  Parses a given frequency and time to a tuple.

  ## Example

      iex> Cronex.Parser.parse_frequency(:hour)
      {0, :*, :*, :*, :*}

      iex> Cronex.Parser.parse_frequency(:day, "10:00")
      {0, 10, :*, :*, :*}

      iex> Cronex.Parser.parse_frequency(:day, "12:10")
      {10, 12, :*, :*, :*}
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
    end
  end

  defp parse_time(time) when is_bitstring(time) do
    time 
    |> String.split(":")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple
  end
end
