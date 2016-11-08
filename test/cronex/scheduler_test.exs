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

  setup_all do
    Application.put_env(:cronex, :scheduler, __MODULE__.TestScheduler)
  end

  setup do
    {:ok, table} = Cronex.Table.start_link(nil)
    {:ok, table: table}
  end

  test "loads jobs from TestScheduler", %{table: table} do
    assert %{0 => %Job{}, 1 => %Job{}} = Cronex.Table.get_jobs(table)
  end
end
