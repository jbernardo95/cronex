defmodule Cronex.Job do
  @moduledoc """
  This module represents a job.
  """
  use GenServer

  defstruct id: nil,
            task: nil,
            args: nil,
            interval: nil

  def start_link(job, opts \\ []) do
    GenServer.start_link(__MODULE__, job)
  end

  def init(job) do
    {:ok, {job, work_timer(job)}}
  end

  def handle_info(:work, {job, _timer}) do
    IO.puts "working"

    {:noreply, {job, work_timer(job)}}
  end

  defp work_timer(job) do
    # TODO change time
    # Process.send_after(self, :work, 2000)
  end
end
