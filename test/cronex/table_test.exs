defmodule Cronex.TableTest do
  use ExUnit.Case
  doctest Cronex.Table, except: [add_job: 2, get_jobs: 1]

  alias Cronex.Job

  setup do
    {:ok, table} = Cronex.Table.start_link(scheduler: nil)
    {:ok, table: table}
  end

  describe "add_job/2" do
    test "returns :ok", %{table: table} do
      task = fn -> IO.puts("Task") end
      job = Cronex.Job.new(:day, task) 

      assert :ok == Cronex.Table.add_job(table, job)
    end
  end

  describe "get_jobs/1" do
    test "with no jobs return %{}", %{table: table} do
      assert %{} == Cronex.Table.get_jobs(table)
    end

    test "with one job return %{0 => %Job{}}", %{table: table} do
      task = fn -> :ok end
      job = Job.new(:day, task) 

      assert :ok == Cronex.Table.add_job(table, job)

      assert %{0 => table_job} = Cronex.Table.get_jobs(table)
      assert table_job == job
    end
  end
end
