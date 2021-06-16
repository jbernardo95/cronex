defmodule Cronex.SchedulerTest do
  use ExUnit.Case
  use Cronex.Test

  alias Cronex.Job
  alias Cronex.Test

  @timeout 150

  defmodule TestScheduler do
    use Cronex.Scheduler

    every :hour do
      send(test_process(), {:ok, :every_hour})
    end

    every :day, at: "10:00" do
      send(test_process(), {:ok, :every_day})
    end

    every :friday, at: "12:00" do
      send(test_process(), {:ok, :every_friday})
    end

    every [:monday, :tuesday], at: "14:00" do
      send(test_process(), {:ok, :every_monday_and_tuesday})
    end

    every 2, :hour do
      send(test_process(), {:ok, :every_2_hour})
    end

    every 3, :day, at: "15:30" do
      send(test_process(), {:ok, :every_3_day})
    end

    defp test_process do
      Application.get_env(:cronex, :test_process)
    end
  end

  setup_all do
    {:ok, _} = TestScheduler.start_link()
    :ok
  end

  setup do
    Application.put_env(:cronex, :test_process, self())
  end

  test "loads jobs from TestScheduler" do
    assert %{0 => %Job{}, 1 => %Job{}, 2 => %Job{}} = Cronex.Table.get_jobs(TestScheduler.table())
    assert 6 == Cronex.Table.get_jobs(TestScheduler.table()) |> map_size
  end

  test "TestScheduler starts table and task supervisor" do
    assert %{active: 2, specs: 2, supervisors: 1, workers: 1} ==
             Supervisor.count_children(__MODULE__.TestScheduler)
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

  test "every monday and tuesday job runs on the expected time" do
    # day_of_week == 1
    Test.DateTime.set(year: 2021, month: 6, day: 14, hour: 14, minute: 0)
    assert_receive {:ok, :every_monday_and_tuesday}, @timeout

    Test.DateTime.set(hour: 15)
    refute_receive {:ok, :every_monday_and_tuesday}, @timeout

    # day_of_week == 2
    Test.DateTime.set(day: 15, hour: 14, minute: 0)
    assert_receive {:ok, :every_monday_and_tuesday}, @timeout

    Test.DateTime.set(hour: 15)
    refute_receive {:ok, :every_monday_and_tuesday}, @timeout
  end

  test "every 2 hour job runs on the expected time" do
    Test.DateTime.set(hour: 0, minute: 0)
    assert_receive {:ok, :every_2_hour}, @timeout

    Test.DateTime.set(hour: 1)
    refute_receive {:ok, :every_2_hour}, @timeout

    Test.DateTime.set(hour: 2)
    assert_receive {:ok, :every_2_hour}, @timeout
  end

  test "every 3 day job runs on the expected time" do
    Test.DateTime.set(day: 1, hour: 15, minute: 30)
    assert_receive {:ok, :every_3_day}, @timeout

    Test.DateTime.set(day: 2)
    refute_receive {:ok, :every_3_day}, @timeout

    Test.DateTime.set(day: 4)
    assert_receive {:ok, :every_3_day}, @timeout

    Test.DateTime.set(hour: 16)
    refute_receive {:ok, :every_3_day}, @timeout
  end

  test "every hour job is defined inside TestScheduler" do
    assert_job_every(:hour, in: TestScheduler)
  end

  test "every day job at 10:00 is defined inside TestScheduler" do
    assert_job_every(:day, at: "10:00", in: TestScheduler)
  end

  test "every friday job at 12:00 is defined inside TestScheduler" do
    assert_job_every(:day, at: "10:00", in: TestScheduler)
  end

  test "every 2 hour job is defined inside TestScheduler" do
    assert_job_every(2, :hour, in: TestScheduler)
  end

  test "every 3 day job at 15:30 is defined inside TestScheduler" do
    assert_job_every(3, :day, at: "15:30", in: TestScheduler)
  end
end
