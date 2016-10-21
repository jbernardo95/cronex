defmodule Cronex.Every do
  @moduledoc """
  This module defines scheduling macros.
  """

  defmacro every(frequency, do: block) do
    quote do
      IO.puts "EVERY: #{unquote(frequency)}"
      IO.puts "DO: #{unquote(block)}"
    end
  end
end
