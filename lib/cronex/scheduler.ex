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
        Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
      end

      @doc false
      def init(_opts) do
        children = [
          supervisor(Task.Supervisor, [[name: job_supervisor()]]),
          worker(Cronex.Table, [[scheduler: __MODULE__], [name: table()]])
        ]

        supervise(children, strategy: :one_for_one)
      end
      
      @doc false
      def job_supervisor do
        :"#{__MODULE__}.JobSupervisor" 
      end

      @doc false
      def table do
        :"#{__MODULE__}.Table" 
      end
    end
  end
end
