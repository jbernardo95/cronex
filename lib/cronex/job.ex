defmodule Cronex.Job do
  @moduledoc """
  This module represents a job.
  """

  import Cronex.Parser

  defstruct frequency: nil,
            task: nil,
            pid: nil

  @doc """
  Creates a `%Job{}` with a given frequency and task.

  Check `Cronex.Every.every/3` documentation, to view the accepted `frequency` arguments.
  """
  def new(frequency, task)
      when is_atom(frequency) and is_function(task) do
    %Cronex.Job{}
    |> Map.put(:frequency, parse_regular_frequency(frequency))
    |> Map.put(:task, task)
  end

  @doc """
  Creates a `%Job{}` with the given arguments.

  Different argument data types combinations are accepted:

  - When `arg1` is an atom and `arg2` is a string, they represent the `frequency` and `time` respectively.

  - When `arg1` is an integer and `arg2` is an atom, they represent the `interval` and `frequency` respectively.

  Check `Cronex.Every.every/3` documentation, to view the accepted `frequency` and `time` arguments.
  """
  def new(arg1, arg2, task)
      when is_atom(arg1) and is_bitstring(arg2) and is_function(task) do
    %Cronex.Job{}
    |> Map.put(:frequency, parse_regular_frequency(arg1, arg2))
    |> Map.put(:task, task)
  end

  def new(arg1, arg2, task)
      when is_integer(arg1) and is_atom(arg2) and is_function(task) do
    %Cronex.Job{}
    |> Map.put(:frequency, parse_interval_frequency(arg1, arg2))
    |> Map.put(:task, task)
  end

  def new(arg1, arg2, task)
      when is_list(arg1) and is_bitstring(arg2) and is_function(task) do
    %Cronex.Job{}
    |> Map.put(:frequency, parse_regular_frequency(arg1, arg2))
    |> Map.put(:task, task)
  end

  @doc """
  Creates a `%Job{}` with the given interval, frequency, time and task.

  Check `Cronex.Every.every/4` documentation, to view the accepted `interval`, `frequency` and `time` arguments.
  """
  def new(interval, frequency, time, task)
      when is_integer(interval) and is_atom(frequency) and is_function(task) do
    %Cronex.Job{}
    |> Map.put(:frequency, parse_interval_frequency(interval, frequency, time))
    |> Map.put(:task, task)
  end

  @doc """
  Validates a given `%Job{}`.

  Returns the given %Job{} if the job is valid, raises an error if the job is invalid.
  """
  def validate!(%Cronex.Job{frequency: frequency} = job) do
    case frequency do
      :invalid -> raise_invalid_frequency_error()
      _ -> job
    end
  end

  @doc """
  Runs and updates the pid attribute of a given `%Job{}`.
  """
  def run(%Cronex.Job{task: task} = job, supervisor) do
    {:ok, pid} = Task.Supervisor.start_child(supervisor, task)
    job |> Map.put(:pid, pid)
  end

  @doc """
  Checks if a given `%Job{}` can run, based on it's frequency and pid.
  """
  def can_run?(%Cronex.Job{} = job) do
    # TODO Process.alive? only works for local processes, improve this to support several nodes

    # Is time to run
    # Job process is dead or non existing
    is_time(job.frequency) and (job.pid == nil or !Process.alive?(job.pid))
  end

  defp raise_invalid_frequency_error do
    raise ArgumentError, """
    An invalid frequency was given when creating a job.

    Check the docs to see the accepted frequency arguments.
    """
  end

  # Every minute job
  defp is_time({:*, :*, :*, :*, :*}), do: true

  # Every interval minute job, check interval minute
  defp is_time({interval, :*, :*, :*, :*}) when is_function(interval) do
    interval.(current_date_time().minute) == 0
  end

  # Every hour job, check minute of job
  defp is_time({minute, :*, :*, :*, :*})
       when is_integer(minute) do
    current_date_time().minute == minute
  end

  # Every interval hour job, check minute of job and interval hour
  defp is_time({minute, interval, :*, :*, :*})
       when is_integer(minute) and is_function(interval) do
    current_date_time().minute == minute and interval.(current_date_time().hour) == 0
  end

  # Every day job, check time of job
  defp is_time({minute, hour, :*, :*, :*})
       when is_integer(minute) and is_integer(hour) do
    current_date_time().minute == minute and current_date_time().hour == hour
  end

  # Every interval day job, check time of job and interval day
  defp is_time({minute, hour, interval, :*, :*})
       when is_integer(minute) and is_integer(hour) and is_function(interval) do
    current_date_time().minute == minute and current_date_time().hour == hour and
      interval.(current_date_time().day - 1) == 0
  end

  # Every days of week job, check time and list of days of the week
  defp is_time({minute, hour, :*, :*, days_of_week}) when is_list(days_of_week) do
    Enum.any?(days_of_week, &is_time({minute, hour, :*, :*, &1}))
  end

  # Every week job, check time and day of the week
  defp is_time({minute, hour, :*, :*, day_of_week}) do
    current_date_time().minute == minute and current_date_time().hour == hour and
      Date.day_of_week(current_date_time()) == day_of_week
  end

  # Every month job, check time and day of job
  defp is_time({minute, hour, day, :*, :*})
       when is_integer(minute) and is_integer(hour) and is_integer(day) do
    current_date_time().minute == minute and current_date_time().hour == hour and
      current_date_time().day == day
  end

  # Every interval month job, check time, day and interval month
  defp is_time({minute, hour, day, interval, :*})
       when is_integer(minute) and is_integer(hour) and is_integer(day) and is_function(interval) do
    current_date_time().minute == minute and current_date_time().hour == hour and
      current_date_time().day == day and interval.(current_date_time().month - 1) == 0
  end

  # Every year job, check month, day and time of job
  defp is_time({minute, hour, day, month, :*}) do
    current_date_time().minute == minute and current_date_time().hour == hour and
      current_date_time().day == day and current_date_time().month == month
  end

  defp is_time(_frequency), do: false

  defp current_date_time do
    date_time_provider = Application.get_env(:cronex, :date_time_provider, DateTime)
    date_time_provider.utc_now
  end
end
