defmodule Cronex.Supervisor do
  @moduledoc """
  This module supervises the slave processes.
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

  def stop_job(%Job{} = job) do
    slave = get_job_slave(job)
    Supervisor.terminate_child(:cronex_supervisor, slave)
  end

  def childs do
    Supervisor.which_children(:cronex_supervisor)
  end


  # Callbacks
  
  def init(_) do
    children = [
      worker(Cronex.Slave, [], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end


  # Private

  defp get_job_slave(%Job{} = job) do
    slaves = Supervisor.which_children(:cronex_supervisor)
    # TODO search for job based on job[:id]
  end
end
