defmodule Cronex.Table do
  @moduledoc """
  This module represents a cron table.
  """

  use GenServer

  import Cronex.Job

  alias Cronex.Job

  # Interface functions
  def start_link(args, opts \\ []) do
    GenServer.start_link(__MODULE__, args, opts)
  end

  @doc false
  def add_job(pid, %Job{} = job) do
    GenServer.call(pid, {:add_job, job})
  end

  @doc false
  def get_jobs(pid) do
    GenServer.call(pid, :get_jobs)
  end

  # Callback functions
  def init(args) do
    GenServer.cast(self(), :init)

    state = %{scheduler: args[:scheduler],
              jobs: Map.new,
              timer: new_ping_timer()}

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
    updated_timer = new_ping_timer()

    updated_jobs =
      for {id, job} <- state[:jobs], into: %{} do
        updated_job =
          if job |> can_run? do
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

  defp new_ping_timer() do
    Process.send_after(self(), :ping, ping_interval())
  end

  defp ping_interval do
    case Mix.env do
      :prod -> 30000
      :dev -> 30000
      :test -> 100
    end
  end
end
