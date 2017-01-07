defmodule Cronex.Job do
  @moduledoc """
  This module represents a job.
  """

  import Cronex.Parser 

  defstruct frequency: nil,
            task: nil,
            pid: nil

  @doc"""
  Creates a `%Job{}` with a given frequency and task.
  """
  def new(frequency, task)
    when is_atom(frequency) and is_function(task) do
    %Cronex.Job{}
    |> Map.put(:frequency, parse_frequency(frequency))
    |> Map.put(:task, task)
  end

  @doc"""
  Creates a `%Job{}` with a given frequency, time and task.
  """
  def new(frequency, time, task)
    when is_atom(frequency) and is_bitstring(time) and is_function(task) do
    %Cronex.Job{}
    |> Map.put(:frequency, parse_frequency(frequency, time))
    |> Map.put(:task, task)
  end

  @doc"""
  Validates a given %Job{}.

  Returns the given %Job{} if the job is valid, raises an error if the job is invalid.
  """
  def validate!(%Cronex.Job{frequency: frequency} = job) do
    case frequency do
      :invalid -> raise_invalid_frequency_error()
      _ -> job
    end
  end

  @doc"""
  Runs and updates the pid attribute of a given `%Job{}`.
  """
  def run(%Cronex.Job{task: task} = job, supervisor) do
    {:ok, pid} = Task.Supervisor.start_child(supervisor, task)
    job |> Map.put(:pid, pid)
  end

  @doc"""
  Checks if a given `%Job{}` can run, based on it's frequency and pid.
  """
  def can_run?(%Cronex.Job{} = job) do
    # TODO Process.alive? only works for local processes, improve this to support several nodes
    
    is_time(job.frequency) and # Is time to run
    (job.pid == nil or !Process.alive?(job.pid)) # Job process is dead or non existing 
  end

  defp raise_invalid_frequency_error do
    raise ArgumentError, """
    An invalid frequency was given when creating a job.

    Check the docs to see the accepted frequency arguments. 
    """
  end

  # Every minute job
  defp is_time({:*, :*, :*, :*, :*}), do: true

  # Every hour job, check minute of job
  defp is_time({minute, :*, :*, :*, :*}) do
    current_date_time().minute == minute
  end

  # Every day job, check time of job
  defp is_time({minute, hour, :*, :*, :*}) do
    current_date_time().minute == minute and current_date_time().hour == hour
  end

  # Every week job, check time and day of the week
  defp is_time({minute, hour, :*, :*, day_week}) do
    current_date_time().minute == minute and current_date_time().hour == hour and Date.day_of_week(current_date_time()) == day_week
  end

  # Every month job, check day and time of job
  defp is_time({minute, hour, day, :*, :*}) do
    current_date_time().minute == minute and current_date_time().hour == hour and current_date_time().day == day
  end

  # Every year job, check month, day and time of job
  defp is_time({minute, hour, day, month, :*}) do
    current_date_time().minute == minute and 
    current_date_time().hour == hour and
    current_date_time().day == day and
    current_date_time().month == month
  end

  defp is_time(_frequency), do: false

  defp current_date_time do
    date_time_provider = Application.get_env(:cronex, :date_time_provider, DateTime)
    date_time_provider.utc_now
  end
end
