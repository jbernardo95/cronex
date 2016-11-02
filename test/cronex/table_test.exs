defmodule Cronex.TableTest do
  use ExUnit.Case
  doctest Cronex.Table, except: [get_jobs: 0, get_jobs: 1]

  alias Cronex.Job

  setup do
    {:ok, table} = Cronex.Table.start_link(nil)
    {:ok, table: table}
  end

  describe "get_jobs/1" do
    test "with no jobs return %{}", %{table: table} do
      assert %{} == Cronex.Table.get_jobs(table)
    end

    test "with one jobs return %{0 => %Job{}}", %{table: table} do
      task = fn -> :ok end
      job = Job.new(:day, task) 

      assert :ok == Cronex.Table.add_job(table, job)

      assert %{0 => table_job} = Cronex.Table.get_jobs(table)
      assert table_job == job
    end
  end
end
