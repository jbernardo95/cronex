defmodule Cronex.Supervisor do
  @moduledoc """
  This module supervises the slave processes.
  """
  use Supervisor

  def start_link(arg, opts \\ []) do
    Supervisor.start_link(__MODULE__, arg, opts)
  end

  def init(_) do
    children = [
      worker(Cronex.Slave, [])
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
