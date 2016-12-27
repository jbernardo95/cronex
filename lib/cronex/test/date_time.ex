defmodule Cronex.Test.DateTime do
  def start_link do
    Agent.start_link(fn -> Cronex.DateTime.current end, name: __MODULE__)
  end

  def set(%Cronex.DateTime{} = date_time) do
    Agent.update(__MODULE__, fn(_) -> date_time end)
  end

  def current do
    Agent.get(__MODULE__, &(&1))
  end
end
