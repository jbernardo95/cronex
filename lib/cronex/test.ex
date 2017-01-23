defmodule Cronex.Test do
  @moduledoc """
  This module defines helpers for testing cron jobs definition.
  """

  defmacro __using__(_opts) do
    quote do
      import Cronex.Test
    end
  end

  @doc """
  Checks if a job with the specified `frequency` and `time` is defined inside the given `scheduler`.

  `time` (optional) and `scheduler` should be passed inside `opts` as a keyword list.

  You can also specify how many jobs with the given `frequency` and `time` should be defined using the `count` parameter inside the `opts` list. It defaults to 1.

  ## Example

      # Asserts if an every hour job is defined in MyApp.Scheduler
      assert_job_every :hour, in: MyApp.Scheduler

      # Asserts if an every day job at 10:00 is defined in MyApp.Scheduler
      assert_job_every :day, at: "10:00", in: MyApp.Scheduler

      # Asserts if 3 every day jobs at 10:00 are defined in MyApp.Scheduler
      assert_job_every :day, at: "10:00", in: MyApp.Scheduler, count: 3
  """
  defmacro assert_job_every(frequency, opts)
    when is_atom(frequency) do

    time = Keyword.get(opts, :at, "00:00")
    scheduler = Keyword.get(opts, :in)
    count = Keyword.get(opts, :count, 1)

    quote bind_quoted: [frequency: frequency, time: time, scheduler: scheduler, count: count] do
      assert count == Cronex.Table.get_jobs(scheduler.table)
        |> Map.values
        |> Enum.count(fn(%Cronex.Job{frequency: job_frequency}) ->
          job_frequency == Cronex.Parser.parse_regular_frequency(frequency, time)
        end)
    end
  end

  @doc """
  Checks if a job with the specified `interval`, `frequency` and `time` is defined inside the given `scheduler`.

  `time` (optional) and `scheduler` should be passed inside `opts` as a keyword list.

  You can also specify how many jobs with the given `frequency` and `time` should be defined using the `count` parameter inside the `opts` list. It defaults to 1.

  ## Example

      # Asserts if an every hour job is defined in MyApp.Scheduler
      assert_job_every 2, :hour, in: MyApp.Scheduler

      # Asserts if an every day job at 10:00 is defined in MyApp.Scheduler
      assert_job_every 3, :day, at: "10:00", in: MyApp.Scheduler

      # Asserts if 3 every day jobs at 10:00 are defined in MyApp.Scheduler
      assert_job_every 3, :day, at: "10:00", in: MyApp.Scheduler, count: 3
  """
  defmacro assert_job_every(interval, frequency, opts)
    when is_integer(interval) and is_atom(frequency) do

    time = Keyword.get(opts, :at, "00:00")
    scheduler = Keyword.get(opts, :in)
    count = Keyword.get(opts, :count, 1)

    quote bind_quoted: [interval: interval, frequency: frequency, time: time, scheduler: scheduler, count: count] do
      assert count == Cronex.Table.get_jobs(scheduler.table)
        |> Map.values
        |> Enum.count(fn(%Cronex.Job{frequency: job_frequency}) ->
          job_frequency == Cronex.Parser.parse_interval_frequency(interval, frequency, time)
        end)
    end
  end
end
