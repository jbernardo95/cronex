defmodule Cronex.Table do
  @moduledoc """
  This module represents a cron table.
  """

  use GenServer

  alias Cronex.Job

  # Interface functions
  def start_link(args, opts \\ []) do
    merged_opts = opts ++ [name: :cronex_table]
    GenServer.start_link(__MODULE__, args, merged_opts)
  end

  def add_job(%Job{} = job) do
    GenServer.call(:cronex_table, {:add_job, job})
  end

  def get_jobs do
    GenServer.call(:cronex_table, :get_jobs)
  end

  # Callback functions
  def init(_args) do
    state = %{jobs: Map.new, timer: work_timer}
    {:ok, state}
  end

  def handle_call({:add_job, %Job{} = job}, _from, state) do
    index = state[:jobs] |> Map.keys |> Enum.count 
    new_state = put_in(state, [:jobs, index], job)
    {:reply, :ok, new_state}
  end

  def handle_call(:get_jobs, _from, state) do
    {:reply, state[:jobs], state}
  end

  def handle_info(:work, state) do
    IO.puts "Working !"

    # Map through all jobs and deploy processes

    new_state = state |> Map.put(:timer, work_timer)
    {:noreply, new_state}
  end

  # Private functions
  defp work_timer do
    Process.send_after(self, :work, 60000) # 1 min
  end
end
