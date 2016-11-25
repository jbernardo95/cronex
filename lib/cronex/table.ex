defmodule Cronex.Table do
  @moduledoc """
  This module represents a cron table.
  """

  use GenServer

  alias Cronex.Job
  import Cronex.Job

  # Interface functions
  def start_link(args, opts \\ []) do
    GenServer.start_link(__MODULE__, args, opts)
  end

  @doc"""
  Adds a `%Cronex.Job{}` to the cronex table.

  ## Example
  
      iex> task = fn -> IO.puts("Task") end
      iex> job = Cronex.Job.new(:day, task) 
      iex> Cronex.Table.add_job(table_pid, job)
      :ok
  """
  def add_job(pid, %Job{} = job) do
    GenServer.call(pid, {:add_job, job})
  end

  @doc"""
  Returns a map of the jobs on the cronex table.

  ## Example
  
      iex> Cronex.Table.get_jobs(table_pid)
      %{0 => %Cronex.Job{...}}
  """
  def get_jobs(pid) do
    GenServer.call(pid, :get_jobs)
  end

  # Callback functions
  def init(args) do
    GenServer.cast(self, :init)

    state = %{scheduler: args[:scheduler],
              jobs: Map.new,
              timer: ping_timer}

    {:ok, state}
  end

  def handle_cast(:init, %{scheduler: nil} = state), do: {:noreply, state} 
  def handle_cast(:init, %{scheduler: scheduler} = state) do
    new_state =
      scheduler.__info__(:functions)
      |> Enum.reduce(state, fn({function, _arity}, state) ->
        if Atom.to_string(function) =~ "job_every_" do
          job = apply(scheduler, function, [])
          state |> do_add_job(job)
        else
          state
        end
      end)

    {:noreply, new_state}
  end

  def handle_call({:add_job, %Job{} = job}, _from, state) do
    new_state = state |> do_add_job(job)
    {:reply, :ok, new_state}
  end

  def handle_call(:get_jobs, _from, state) do
    {:reply, state[:jobs], state}
  end

  def handle_info(:ping, %{scheduler: scheduler} = state) do
    updated_timer = ping_timer

    updated_jobs =
      for {id, job} <- state[:jobs], into: %{} do
        updated_job =
          if job |> can_run do
            job |> run(scheduler.job_supervisor)
          else
            job
          end

        {id, updated_job}
      end

    new_state = %{state | timer: updated_timer, jobs: updated_jobs}
    {:noreply, new_state}
  end

  # Private functions
  defp do_add_job(state, %Job{} = job) do
    index = state[:jobs] |> Map.keys |> Enum.count 
    put_in(state, [:jobs, index], job)
  end

  defp ping_timer do
    Process.send_after(self, :ping, 30000) # 30 sec 
  end
end
