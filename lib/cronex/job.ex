defmodule Cronex.Job do
  @moduledoc """
  This module represents a job.
  """

  defstruct frequency: nil,
            time: nil,
            task: nil

  def new(frequency, task) do
    %Cronex.Job{}
    |> Map.put(:frequency, frequency)
    |> Map.put(:task, task)
  end

  def new(frequency, time, task) do
    %Cronex.Job{}
    |> Map.put(:frequency, frequency)
    |> Map.put(:time, time)
    |> Map.put(:task, task)
  end

  def start_link(_opts) do
    # run job code
  end
end
