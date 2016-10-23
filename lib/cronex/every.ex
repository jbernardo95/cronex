defmodule Cronex.Every do
  @moduledoc """
  This module defines scheduling macros.
  """

  defmacro every(frequency, do: block) do
    quote do
      job = Cronex.Job.new(unquote(frequency), fn -> unquote(block) end)
      Cronex.Table.add_job(job)

      IO.puts "EVERY: #{unquote(frequency)}"
      IO.puts "DO: #{unquote(block)}"
      IO.inspect job
    end
  end

  defmacro every(frequency, at: time, do: block) do
    quote do
      job = Cronex.Job.new(unquote(frequency), unquote(time), fn -> unquote(block) end)
      Cronex.Table.add_job(job)

      IO.puts "EVERY: #{unquote(frequency)}"
      IO.puts "DO: #{unquote(block)}"
      IO.inspect job
    end
  end
end
