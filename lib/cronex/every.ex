defmodule Cronex.Every do
  @moduledoc """
  This module defines scheduling macros.
  """

  defmacro __using__(_opts) do
    quote do
      import Cronex.Every
    end
  end

  @doc"""
  `Cronex.Every.every/2` macro is used as a simple interface to add a job (without time) to the `Cronex.Table`.

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
  defmacro every(frequency, [do: block] = _job) do
    quote do
      @doc false
      def unquote(:"job_every_#{frequency}")() do
        Cronex.Job.new(unquote(frequency), fn -> unquote(block) end)
        |> Cronex.Job.validate!
      end
    end
  end

  @doc"""
  `Cronex.Every.every/3` macro is used as a simple interface to add a job (with time) to the `Cronex.Table`.

  ## Input Arguments
  
  `frequency` supports the following values: `:minute`, `:hour`, `:day`, `:month`, `:year`, `:monday`, `:tuesday`, `:wednesday`, `:thursday`, `:friday`, `:saturday`, `:sunday`

  `at` must be a list with the following structure: `[at: time]`, where `time` is a string with the following format `HH:MM`, where `HH` represents the hour and `MM` the minutes at which the job should be run, this value is ignored when given in an every minute or every hour job 
  
  `job` must be a list with the following structure: `[do: block]`, where `block` is the code corresponding to a specific job

  ## Example
  
      every :day, at: "10:00", do
        # Daily task at 10:00 here 
      end

      every :monday, at: "12:00", do
        # Monday task at 12:00 here 
      end
  """
  defmacro every(frequency, [at: time] = _at, [do: block] = _job) do
    quote do
      @doc false
      def unquote(:"job_every_#{frequency}_at_#{time}")() do
        Cronex.Job.new(unquote(frequency), unquote(time), fn -> unquote(block) end)
        |> Cronex.Job.validate!
      end
    end
  end
end
