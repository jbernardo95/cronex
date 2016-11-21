defmodule Cronex.Scheduler do
  @moduledoc """
  This module implements a scheduler.

  It is responsible for scheduling jobs.
  """

  defmacro __using__(_opts) do
    quote do
      require Cronex.Every
      import Cronex.Every
    end
  end
end
