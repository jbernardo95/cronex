defmodule Cronex.JobTest do
  use ExUnit.Case

  alias Cronex.Job
  alias Cronex.Test

  test "new/2 returns a %Job{}" do
    task = fn -> :ok end
    job = Job.new(:day, task)

    assert job == %Job{frequency: {0, 0, :*, :*, :*}, task: task}
  end

  test "new/3 regular returns a %Job{}" do
    task = fn -> :ok end
    job = Job.new(:day, "10:00", task)

    assert job == %Job{frequency: {0, 10, :*, :*, :*}, task: task}
  end

  test "new/3 interval returns a %Job{}" do
    task = fn -> :ok end
    job = Job.new(2, :hour, task)

    assert %Job{frequency: {0, interval, :*, :*, :*}, task: t} = job
    assert t == task
    assert is_function(interval)
  end

  test "new/4 returns a %Job{}" do
    task = fn -> :ok end
    job = Job.new(2, :day, "10:30", task)

    assert %Job{frequency: {30, 10, interval, :*, :*}, task: t} = job
    assert t == task
    assert is_function(interval)
  end

  describe "validate!/1" do
    test "returns the given job if the job is valid" do
      task = fn -> :ok end
      job = Job.new(:day, "10:00", task)

      assert job == Job.validate!(job)
    end

    test "raises invalid frequency error when a job with an invalid frequency is given" do
      task = fn -> :ok end
      job = Job.new(:invalid_frequency, task)

      assert_raise ArgumentError, fn ->
        Job.validate!(job)
      end
    end
  end

  test "run/1 returns updated %Job{}" do
    {:ok, job_supervisor} = Task.Supervisor.start_link()

    task = fn -> :ok end
    job = Job.new(:day, task)

    assert job.pid == nil
    %Job{pid: pid} = Job.run(job, job_supervisor)
    assert pid != nil
  end

  test "can_run?/1 with an every minute job returns true" do
    task = fn -> :ok end
    job = Job.new(:minute, task)

    assert true == Cronex.Job.can_run?(job)
  end

  test "can_run?/1 with an every interval minute job" do
    task = fn -> :ok end
    job = Job.new(2, :minute, task)

    Test.DateTime.set(minute: 0)
    assert true == Cronex.Job.can_run?(job)

    Test.DateTime.set(minute: 1)
    assert false == Cronex.Job.can_run?(job)

    Test.DateTime.set(minute: 2)
    assert true == Cronex.Job.can_run?(job)
  end

  test "can_run?/1 with an every hour job" do
    task = fn -> :ok end
    job = Job.new(:hour, task)

    Test.DateTime.set(minute: 0)
    assert true == Cronex.Job.can_run?(job)

    Test.DateTime.set(minute: 1)
    assert false == Cronex.Job.can_run?(job)
  end

  test "can_run?/1 with an every interval hour job" do
    task = fn -> :ok end
    job = Job.new(2, :hour, task)

    Test.DateTime.set(hour: 0, minute: 0)
    assert true == Cronex.Job.can_run?(job)

    Test.DateTime.set(hour: 1)
    assert false == Cronex.Job.can_run?(job)

    Test.DateTime.set(hour: 2)
    assert true == Cronex.Job.can_run?(job)
  end

  test "can_run?/1 with an every day job" do
    task = fn -> :ok end
    job = Job.new(:day, task)

    Test.DateTime.set(hour: 0, minute: 0)
    assert true == Cronex.Job.can_run?(job)

    Test.DateTime.set(hour: 0, minute: 1)
    assert false == Cronex.Job.can_run?(job)

    Test.DateTime.set(hour: 1, minute: 0)
    assert false == Cronex.Job.can_run?(job)

    Test.DateTime.set(hour: 1, minute: 1)
    assert false == Cronex.Job.can_run?(job)
  end

  test "can_run?/1 with an every interval day job" do
    task = fn -> :ok end
    job = Job.new(2, :day, task)

    Test.DateTime.set(day: 1, hour: 0, minute: 0)
    assert true == Cronex.Job.can_run?(job)

    Test.DateTime.set(day: 2)
    assert false == Cronex.Job.can_run?(job)

    Test.DateTime.set(day: 3)
    assert true == Cronex.Job.can_run?(job)
  end

  test "can_run?/1 with an every week day job" do
    task = fn -> :ok end
    job = Job.new(:wednesday, task)

    # day_of_week == 3
    Test.DateTime.set(year: 2017, month: 1, day: 4, hour: 0, minute: 0)
    assert true == Cronex.Job.can_run?(job)

    # day_of_week == 1
    Test.DateTime.set(year: 2017, month: 1, day: 2, hour: 0, minute: 0)
    assert false == Cronex.Job.can_run?(job)

    # day_of_week == 3
    Test.DateTime.set(year: 2017, month: 1, day: 4, hour: 1, minute: 0)
    assert false == Cronex.Job.can_run?(job)
  end

  test "can_run?/1 with an every month job" do
    task = fn -> :ok end
    job = Job.new(:month, task)

    Test.DateTime.set(day: 1, hour: 0, minute: 0)
    assert true == Cronex.Job.can_run?(job)

    Test.DateTime.set(day: 2, hour: 0, minute: 0)
    assert false == Cronex.Job.can_run?(job)

    Test.DateTime.set(day: 1, hour: 1, minute: 0)
    assert false == Cronex.Job.can_run?(job)
  end

  test "can_run?/1 with an every interval month job" do
    task = fn -> :ok end
    job = Job.new(2, :month, task)

    Test.DateTime.set(month: 1, day: 1, hour: 0, minute: 0)
    assert true == Cronex.Job.can_run?(job)

    Test.DateTime.set(month: 2)
    assert false == Cronex.Job.can_run?(job)

    Test.DateTime.set(month: 3)
    assert true == Cronex.Job.can_run?(job)
  end

  test "can_run?/1 with an every year job" do
    task = fn -> :ok end
    job = Job.new(:year, task)

    Test.DateTime.set(month: 1, day: 1, hour: 0, minute: 0)
    assert true == Cronex.Job.can_run?(job)

    Test.DateTime.set(month: 2, day: 1, hour: 0, minute: 0)
    assert false == Cronex.Job.can_run?(job)

    Test.DateTime.set(month: 1, day: 2, hour: 0, minute: 0)
    assert false == Cronex.Job.can_run?(job)
  end
end
