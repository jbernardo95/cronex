defmodule Cronex.Test.DateTime do
  @module """
  Simple DateTime provider that is static and user manipulated.
  """

  def start_link do
    Agent.start_link(fn -> Cronex.DateTime.current end, name: __MODULE__)
  end

  @doc """
  Sets the DateTime value of the provider.
  """
  def set(%Cronex.DateTime{} = date_time) do
    Agent.update(__MODULE__, fn(_) -> date_time end)
  end

  @doc """
  Gets the current DateTime value of the provider.
  """
  def current do
    Agent.get(__MODULE__, &(&1))
  end
end
