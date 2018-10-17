defmodule Cronex.Test.DateTime do
  @moduledoc """
  Simple DateTime provider that is static and user manipulated.
  """

  def start_link do
    Agent.start_link(fn -> DateTime.from_unix!(0) end, name: __MODULE__)
  end

  @doc """
  Sets the DateTime value of the provider.
  """
  def set(args) when is_list(args) do
    args_map = Enum.into(args, Map.new())
    Agent.update(__MODULE__, fn date_time -> Map.merge(date_time, args_map) end)
  end

  @doc """
  Gets the current DateTime value of the provider.
  """
  def get do
    Agent.get(__MODULE__, & &1)
  end

  @doc """
  An alias for the `get/0` function, to mimic the `DateTime` module behaviour.
  """
  def utc_now, do: get()
end
