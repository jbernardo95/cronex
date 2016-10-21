defmodule Cronex.Job do
  @moduledoc """
  This module represents a job.
  """
  use GenServer

  defstruct frequency: nil,
            time: nil,
            task: nil

  # Job functions
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

  # GenServer functions
  def start_link(job, opts \\ []) do
    GenServer.start_link(__MODULE__, job)
  end

  def init(job) do
    {:ok, {job, work_timer(job)}}
  end

  def handle_info(:work, {job, _timer}) do
    IO.puts "working"

    {:noreply, {job, work_timer(job)}}
  end

  defp work_timer(job) do
    # TODO change time
    # Process.send_after(self, :work, 2000)
  end
end
