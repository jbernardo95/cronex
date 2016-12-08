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
  `Cronex.Every.every` macro is used as a simple interface to add a job to the `Cronex.Table`.

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
      @doc false
      def unquote(:"job_every_#{frequency}")() do
        Cronex.Job.new(unquote(frequency), fn -> unquote(block) end)
      end
    end
  end
  defmacro every(frequency, [at: time], [do: block]) do
    quote do
      @doc false
      def unquote(:"job_every_#{frequency}_at_#{time}")() do
        Cronex.Job.new(unquote(frequency), unquote(time), fn -> unquote(block) end)
      end
    end
  end
end
