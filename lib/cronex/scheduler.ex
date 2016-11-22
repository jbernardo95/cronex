defmodule Cronex.Scheduler do
  @moduledoc """
  This module implements a scheduler.

  It is responsible for scheduling jobs.
  """

  defmacro __using__(_opts) do
    quote do
      use Supervisor
      use Cronex.Every

      def start_link do
        Supervisor.start_link(__MODULE__, [])
      end

      def init(_opts) do
        children = [
          worker(Cronex.Table, [[scheduler: __MODULE__], [name: table_name]]),
          supervisor(Task.Supervisor, [[name: job_supervisor_name]])
        ]

        supervise(children, strategy: :one_for_one)
      end

      @doc false
      def table_name do
        :"#{__MODULE__}.Table" 
      end
      
      @doc false
      def job_supervisor_name do
        :"#{__MODULE__}.JobSupervisor" 
      end
    end
  end
end
