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

  def stop_job(%Job{} = job) do
    job_pid = get_job_process(job)
    Supervisor.terminate_child(:cronex_supervisor, job_pid)
  end

  def childs do
    Supervisor.which_children(:cronex_supervisor)
  end


  # Callbacks
  
  def init(_) do
    children = [
      worker(Job, [], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end


  # Private

  defp get_job_process(%Job{} = job) do
    processes = Supervisor.which_children(:cronex_supervisor)
    # TODO search for job based on job[:id]
  end
end
