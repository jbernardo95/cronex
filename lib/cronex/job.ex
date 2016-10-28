defmodule Cronex.Job do
  @moduledoc """
  This module represents a job.
  """

  import Cronex.Parser 

  defstruct frequency: nil,
            task: nil,
            pid: nil

  def new(frequency, task)
    when is_atom(frequency) and is_function(task) do
    %Cronex.Job{}
    |> Map.put(:frequency, parse_frequency(frequency))
    |> Map.put(:task, task)
  end

  def new(frequency, time, task)
    when is_atom(frequency) and is_bitstring(time) and is_function(task) do
    %Cronex.Job{}
    |> Map.put(:frequency, parse_frequency(frequency, time))
    |> Map.put(:task, task)
  end

  def run(%Cronex.Job{task: task} = job) do
    # TODO add logging message
    {:ok, pid} = Task.Supervisor.start_child(:cronex_job_supervisor, task)
    job |> Map.put(:pid, pid)
  end

  def can_run(%Cronex.Job{} = job) do
    # TODO Process.alive? function only works for local processes, improve this to support several nodes
    
    is_time(job.frequency) and # Is time to run
    (job.pid == nil or !Process.alive?(job.pid)) # Job process is dead or non existing 
  end

  # Every minute job
  defp is_time({:*, :*, :*, :*, :*}), do: true

  # Every hour job, check minute of job
  defp is_time({minute, :*, :*, :*, :*}) do
    DateTime.utc_now.minute == minute
  end

  # Every day job, check time of job
  defp is_time({minute, hour, :*, :*, :*}) do
    current_time = DateTime.utc_now
    current_time.minute == minute and current_time.hour == hour
  end

  # Every week job, check time and day of the week
  defp is_time({minute, hour, :*, :*, day_week}) do
    current_time = DateTime.utc_now
    current_day_week = current_time |> DateTime.to_date |> Date.to_erl |> :calendar.day_of_the_week
    current_time.minute == minute and current_time.hour == hour and current_day_week == day_week
  end

  # Every month job, check day and time of job
  defp is_time({minute, hour, day, :*, :*}) do
    current_time = DateTime.utc_now
    current_time.minute == minute and current_time.hour == hour and current_time.day == day
  end

  # Every year job, check month, day and time of job
  defp is_time({minute, hour, day, month, :*}) do
    current_time = DateTime.utc_now
    current_time.minute == minute and 
    current_time.hour == hour and
    current_time.day == day and
    current_time.month == month
  end

  defp is_time(_frequency), do: false
end
