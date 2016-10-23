defmodule Cronex.Supervisor do
  @moduledoc """
  This module supervises the job's processes.
  """
  use Supervisor

  alias Cronex.Job

  # Interface functions
  
  def start_link do
    opts = [name: :cronex_supervisor]
    Supervisor.start_link(__MODULE__, nil, opts)
  end

  def start_job(%Job{} = job) do
    Supervisor.start_child(:cronex_supervisor, [job, []])
  end

  # Callbacks
  
  def init(_) do
    children = [
      worker(Job, [], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
