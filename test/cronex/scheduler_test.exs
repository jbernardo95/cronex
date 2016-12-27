defmodule Cronex.SchedulerTest do
  use ExUnit.Case

  alias Cronex.Job
  alias Cronex.Test

  @timeout 150

  defmodule TestScheduler do
    use Cronex.Scheduler

    every :hour do
      send test_process, {:ok, :every_hour}
    end

    every :day, at: "10:00" do
      send test_process, {:ok, :every_day}
    end

    every :friday, at: "12:00" do
      send test_process, {:ok, :every_friday}
    end

    defp test_process do
      Application.get_env(:cronex, :test_process)
    end
  end

  setup_all do
    {:ok, _} = TestScheduler.start_link
    :ok
  end

  setup do
    Application.put_env(:cronex, :test_process, self)
    Test.DateTime.set(%Cronex.DateTime{minute: 1})
  end

  test "loads jobs from TestScheduler" do
    assert %{0 => %Job{}, 1 => %Job{}} = Cronex.Table.get_jobs(TestScheduler.table)
  end

  test "TestScheduler starts table and task supervisor" do
    assert %{active: 2, specs: 2, supervisors: 1, workers: 1} == Supervisor.count_children(__MODULE__.TestScheduler)
  end

  test "every hour job runs on the expected time" do
    Test.DateTime.set(%Cronex.DateTime{minute: 0})
    assert_receive {:ok, :every_hour}, @timeout 

    Test.DateTime.set(%Cronex.DateTime{minute: 1})
    refute_receive {:ok, :every_hour}, @timeout 
  end

  test "every day job runs on the expected time" do
    Test.DateTime.set(%Cronex.DateTime{hour: 10, minute: 0})
    assert_receive {:ok, :every_day}, @timeout 

    Test.DateTime.set(%Cronex.DateTime{})
    refute_receive {:ok, :every_day}, @timeout 
  end

  test "every friday job runs on the expected time" do
    Test.DateTime.set(%Cronex.DateTime{day_of_week: 5, hour: 12})
    assert_receive {:ok, :every_friday}, @timeout 

    Test.DateTime.set(%Cronex.DateTime{})
    refute_receive {:ok, :every_friday}, @timeout 
  end
end
