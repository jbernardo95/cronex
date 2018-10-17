defmodule Cronex.Scheduler do
  @moduledoc """
  This module implements a scheduler.

  It is responsible for scheduling jobs.
  """

  defmacro __using__(_opts) do
    quote do
      use Supervisor

      import Cronex.Every

      Module.register_attribute(__MODULE__, :jobs, accumulate: true)

      @before_compile unquote(__MODULE__)

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

  defmacro __before_compile__(_opts) do
    quote do
      def jobs do
        @jobs
      end
    end
  end
end
