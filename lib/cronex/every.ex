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
  `Cronex.Every.every/2` macro is used as a simple interface to add a job (without running time) to the `Cronex.Table`.

  ## Input Arguments
  
  `frequency` supports the following values: `:minute`, `hour`, `day`, `month`, `year` 
  
  `job` must be a list with the following structure: `[do: block]`, where `block` is the code refering to a specific job 

  ## Example
  
      every :month, do
        # Monthly task here 
      end
  """
  defmacro every(frequency, [do: block] = _job) do
    quote do
      @doc false
      def unquote(:"job_every_#{frequency}")() do
        Cronex.Job.new(unquote(frequency), fn -> unquote(block) end)
      end
    end
  end

  @doc"""
  `Cronex.Every.every/3` macro is used as a simple interface to add a job (with running time) to the `Cronex.Table`.

  ## Input Arguments
  
  `frequency` supports the following values: `:minute`, `hour`, `day`, `month`, `year` 

  `at` must be a list with the following structure: `[at: time]`, where `time` is a string with the following format `HH:MM`, where `HH` represents the hour and `MM` the minutes at which the job should be run 
  
  `job` must be a list with the following structure: `[do: block]`, where `block` is the code corresponding to a specific job

  ## Example
  
      every :day, at: "10:00", do
        # Daily task at 10:00 here 
      end
  """
  defmacro every(frequency, [at: time] = _at, [do: block] = _job) do
    quote do
      @doc false
      def unquote(:"job_every_#{frequency}_at_#{time}")() do
        Cronex.Job.new(unquote(frequency), unquote(time), fn -> unquote(block) end)
      end
    end
  end
end
