defmodule Cronex.Scheduler do
  @moduledoc """
  This module represents the scheduler entity.
  """

  defmacro __using__(opts) do
    import Cronex.Every
  end
end
