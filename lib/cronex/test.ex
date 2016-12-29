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

  `time` and `scheduler` should be passed inside `opts` as a keyword list.

  You can also specify how many jobs with the given `frequency` and `time` should be defined using the `count` parameter. It defaults to 1.

  ## Example

      # Asserts if an every hour job is defined in MyApp.Scheduler
      assert_job_every :hour, in: MyApp.Scheduler

      # Asserts if an every day job at 10:00 is defined in MyApp.Scheduler
      assert_job_every :day, at: "10:00", in: MyApp.Scheduler
  """
  defmacro assert_job_every(frequency, _opts, count \\ 1)
  defmacro assert_job_every(frequency, [in: scheduler] = _opts, count) do
    quote do
      assert unquote(count) == Cronex.Table.get_jobs(unquote(scheduler).table)
        |> Map.values
        |> Enum.count(fn(%Cronex.Job{frequency: job_frequency}) ->
          job_frequency == Cronex.Parser.parse_frequency(unquote(frequency))
        end)
    end
  end
  defmacro assert_job_every(frequency, [at: time, in: scheduler] = _opts, count) do
    quote do
      assert unquote(count) == Cronex.Table.get_jobs(unquote(scheduler).table)
        |> Map.values
        |> Enum.count(fn(%Cronex.Job{frequency: job_frequency}) ->
          job_frequency == Cronex.Parser.parse_frequency(unquote(frequency), unquote(time))
        end)
    end
  end
end

