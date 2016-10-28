defmodule Cronex.Parser do
  def parse_frequency(frequency, time \\ nil) do
    {hour, minute} = case time do
      nil ->
        {0, 0} # Default time
      time ->
        parse_time(time)
    end

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
    {_hour, _minute} = time |> String.split(":") |> List.to_tuple
  end
end
