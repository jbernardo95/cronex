defmodule Cronex.TableTest do
  use ExUnit.Case
  doctest Cronex.Table, except: [add_job: 2, get_jobs: 1]

  alias Cronex.Job

  defmodule TestScheduler, do: use Cronex.Scheduler

  setup do
    Process.flag(:trap_exit, true)
    {:ok, table} = Cronex.Table.start_link(scheduler: TestScheduler)
    {:ok, table: table}
  end

  describe "start_link/1 & start_link/2" do
    test "raises when no scheduler is given" do
      Cronex.Table.start_link(nil)

      assert_receive {:EXIT, _from, reason}
      assert %ArgumentError{message: message} = elem(reason, 0) 
      assert message =~ "No scheduler was provided"

      Cronex.Table.start_link(scheduler: nil)

      assert_receive {:EXIT, _from, reason}
      assert %ArgumentError{message: message} = elem(reason, 0) 
      assert message =~ "No scheduler was provided"
    end
  end

  describe "add_job/2" do
    test "returns :ok", %{table: table} do
      task = fn -> IO.puts("Task") end
      job = Cronex.Job.new(:day, task) 

      assert :ok == Cronex.Table.add_job(table, job)
    end
  end

  describe "get_jobs/1" do
    test "with no jobs returns %{}", %{table: table} do
      assert %{} == Cronex.Table.get_jobs(table)
    end

    test "with one job returns %{0 => %Job{}}", %{table: table} do
      task = fn -> :ok end
      job = Job.new(:day, task) 

      assert :ok == Cronex.Table.add_job(table, job)

      assert %{0 => table_job} = Cronex.Table.get_jobs(table)
      assert table_job == job
    end
  end
end
