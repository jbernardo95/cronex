defmodule Cronex.Every do
  @moduledoc """
  This module defines scheduling macros.
  """

  @doc """
  `Cronex.Every.every/2` macro is used as a simple interface to add a job to the `Cronex.Table`.

  ## Input Arguments

  `frequency` supports the following values: `:minute`, `:hour`, `:day`, `:month`, `:year`, `:monday`, `:tuesday`, `:wednesday`, `:thursday`, `:friday`, `:saturday`, `:sunday`

  `job` must be a list with the following structure: `[do: block]`, where `block` is the code refering to a specific job 

  ## Example

      every :day, do
        # Daily task here 
      end

      every :month, do
        # Monthly task here 
      end
  """
  defmacro every(frequency, [do: block] = _job)
           when is_atom(frequency) do
    job_name = String.to_atom("job_every_#{frequency}")

    quote do
      @jobs unquote(job_name)

      @doc false
      def unquote(job_name)() do
        Cronex.Job.new(
          unquote(frequency),
          fn -> unquote(block) end
        )
        |> Cronex.Job.validate!()
      end
    end
  end

  @doc """
  `Cronex.Every.every/3` macro is used as a simple interface to add a job to the `Cronex.Table`.

  Different argument data types combinations are accepted:

  - When `arg1` is an atom and `arg2` is a string, they represent the `frequency` and `at` respectively.

  - When `arg1` is an integer and `arg2` is a atom, they represent the `interval` and `frequency` respectively.

  ## Input Arguments

  `frequency` supports the following values `:minute`, `:hour`, `:day`, `:month`, `:year`, `:monday`, `:tuesday`, `:wednesday`, `:thursday`, `:friday`, `:saturday`, `:sunday`, when an `interval` is given, only the following values are accepted `:minute`, `:hour`, `:day`, `:month`

  `interval` must be an integer representing the interval of frequencies that should exist between each job run

  `at` must be a list with the following structure: `[at: time]`, where `time` is a string with the following format `HH:MM`, where `HH` represents the hour and `MM` the minutes at which the job should be run, this value is ignored when given in an every minute or every hour job 

  `job` must be a list with the following structure: `[do: block]`, where `block` is the code corresponding to a specific job

  ## Example

      every :day, at: "10:00", do
        # Daily task at 10:00 here 
      end

      every :monday, at: "12:00", do
        # Monday task at 12:00 here 
      end

      every 2, :day do
        # Every 2 days task
      end

      every 3, :week do
        # Every 3 weeks task
      end
  """
  defmacro every(arg1, [at: time] = _arg2, [do: block] = _job)
           when is_atom(arg1) and is_bitstring(time) do
    job_name = String.to_atom("job_every_#{arg1}_at_#{time}")

    quote do
      @jobs unquote(job_name)

      @doc false
      def unquote(job_name)() do
        Cronex.Job.new(
          unquote(arg1),
          unquote(time),
          fn -> unquote(block) end
        )
        |> Cronex.Job.validate!()
      end
    end
  end

  defmacro every(arg1, arg2, [do: block] = _job)
           when is_integer(arg1) and is_atom(arg2) do
    job_name = String.to_atom("job_every_#{arg1}_#{arg2}")

    quote do
      @jobs unquote(job_name)

      @doc false
      def unquote(job_name)() do
        Cronex.Job.new(
          unquote(arg1),
          unquote(arg2),
          fn -> unquote(block) end
        )
        |> Cronex.Job.validate!()
      end
    end
  end

  @doc """
  `Cronex.Every.every/4` macro is used as a simple interface to add a job to the `Cronex.Table`.

  ## Input Arguments

  `interval` must be an integer representing the interval of frequencies that should exist between each job run

  `frequency` supports the following values: `:minute`, `:hour`, `:day`, `:month`

  `at` must be a list with the following structure: `[at: time]`, where `time` is a string with the following format `HH:MM`, where `HH` represents the hour and `MM` the minutes at which the job should be run, this value is ignored when given in an every minute or every hour job 

  `job` must be a list with the following structure: `[do: block]`, where `block` is the code corresponding to a specific job

  ## Example

      every 2, :day, at: "10:00" do
        # Every 2 days task
      end

      every 3, :week, at: "10:00" do
        # Every 3 weeks task
      end
  """
  defmacro every(interval, frequency, [at: time] = _at, [do: block] = _job)
           when is_integer(interval) and is_atom(frequency) do
    job_name = String.to_atom("job_every_#{interval}_#{frequency}_at_#{time}")

    quote do
      @jobs unquote(job_name)

      @doc false
      def unquote(job_name)() do
        Cronex.Job.new(
          unquote(interval),
          unquote(frequency),
          unquote(time),
          fn -> unquote(block) end
        )
        |> Cronex.Job.validate!()
      end
    end
  end
end
