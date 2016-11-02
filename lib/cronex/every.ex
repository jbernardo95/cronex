defmodule Cronex.Every do
  @moduledoc """
  This module defines scheduling macros.
  """

  @doc"""
  Cronex.Every.every macro is used as a simple interface to add a job to the Cronex.Table.

  ## Example
  
    every :month, do
      # Monthly task here 
    end

    every :day, at: "10:00", do
      # Daily task at 10:00 here 
    end
  """
  defmacro every(frequency, do: block) do
    quote do
      job = Cronex.Job.new(unquote(frequency), fn -> unquote(block) end)
      Cronex.Table.add_job(job)
    end
  end
  defmacro every(frequency, at: time, do: block) do
    quote do
      job = Cronex.Job.new(unquote(frequency), unquote(time), fn -> unquote(block) end)
      Cronex.Table.add_job(job)
    end
  end
end
