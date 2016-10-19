defmodule Cronex.Master do
  @moduledoc """
  This module represents the master server which is responsible for adding (starting) and removing (stopping) jobs.
  """
  use GenServer

  alias Cronex.Job

  # Interface functions
  
  def start_link do
    opts = [name: :cronex_master]
    GenServer.start_link(__MODULE__, nil, opts)
  end

  def add_job(%Job{} = job) do
    GenServer.call(:cronex_master, {:add_job, job})
  end

  def remove_job(%Job{} = job) do
    GenServer.call(:cronex_master, {:remove_job, job})
  end


  # Callbacks

  def init(_) do
    # get jobs from config
    {:ok, nil}
  end

  def handle_call({:add_job, %Job{} = job}, _from, state) do
    job_slave = Cronex.Supervisor.start_job(job)
    {:reply, job_slave, state}
  end

  def handle_call({:remove_job, %Job{} = job}, _from, state) do
    # TODO
    {:reply, nil, state}
  end
end
