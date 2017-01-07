defmodule Cronex.SchedulerTest do
  use ExUnit.Case
  use Cronex.Test

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
  end

  test "loads jobs from TestScheduler" do
    assert %{0 => %Job{}, 1 => %Job{}, 2 => %Job{}} = Cronex.Table.get_jobs(TestScheduler.table)
    assert 3 == (Cronex.Table.get_jobs(TestScheduler.table) |> map_size)
  end

  test "TestScheduler starts table and task supervisor" do
    assert %{active: 2, specs: 2, supervisors: 1, workers: 1} == Supervisor.count_children(__MODULE__.TestScheduler)
  end

  test "every hour job runs on the expected time" do
    Test.DateTime.set(minute: 0)
    assert_receive {:ok, :every_hour}, @timeout 

    Test.DateTime.set(minute: 1)
    refute_receive {:ok, :every_hour}, @timeout 
  end

  test "every day job runs on the expected time" do
    Test.DateTime.set(hour: 10, minute: 0)
    assert_receive {:ok, :every_day}, @timeout 

    Test.DateTime.set(hour: 11)
    refute_receive {:ok, :every_day}, @timeout 
  end

  test "every friday job runs on the expected time" do
    # day_of_week == 5
    Test.DateTime.set(year: 2017, month: 1, day: 6, hour: 12, minute: 0)
    assert_receive {:ok, :every_friday}, @timeout 

    Test.DateTime.set(hour: 13)
    refute_receive {:ok, :every_friday}, @timeout 
  end

  test "every hour job is defined inside TestScheduler" do
    assert_job_every :hour, in: TestScheduler
  end

  test "every day job at 10:00 is defined inside TestScheduler" do
    assert_job_every :day, at: "10:00", in: TestScheduler 
  end

  test "every friday job at 12:00 is defined inside TestScheduler" do
    assert_job_every :day, at: "10:00", in: TestScheduler
  end
end
