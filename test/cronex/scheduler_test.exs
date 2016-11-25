defmodule Cronex.SchedulerTest do
  use ExUnit.Case

  alias Cronex.Job

  defmodule TestScheduler do
    use Cronex.Scheduler

    every :minute do
      IO.puts "Every minute task"
    end

    every :day, at: "10:00" do
      IO.puts "Every day task at 10:00"
    end
  end

  setup do
    {:ok, _scheduler} = TestScheduler.start_link
    :ok
  end

  test "loads jobs from TestScheduler" do
    assert %{0 => %Job{}, 1 => %Job{}} = Cronex.Table.get_jobs(TestScheduler.table)
  end

  test "TestScheduler starts table and task supervisor" do
    assert %{active: 2, specs: 2, supervisors: 1, workers: 1} == Supervisor.count_children(__MODULE__.TestScheduler)
  end
end
