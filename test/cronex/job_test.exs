defmodule Cronex.JobTest do
  use ExUnit.Case

  alias Cronex.Job

  defmodule TestDateTime do
    def start_link do
      Agent.start_link(fn -> Cronex.DateTime.current end, name: __MODULE__)
    end

    def set(%Cronex.DateTime{} = date_time) do
      Agent.update(__MODULE__, fn(_) -> date_time end)
    end

    def current do
      Agent.get(__MODULE__, &(&1))
    end
  end

  setup_all do
    TestDateTime.start_link
    Application.put_env(:cronex, :date_time_provider, __MODULE__.TestDateTime)
    :ok
  end

  setup do
    {:ok, job_supervisor} = Task.Supervisor.start_link 
    {:ok, job_supervisor: job_supervisor}
  end

  test "new/2 returns a %Job{}" do
    task = fn -> :ok end
    job = Job.new(:day, task) 

    assert job == %Job{frequency: {0, 0, :*, :*, :*}, task: task}
  end

  test "new/3 returns a %Job{}" do
    task = fn -> :ok end
    job = Job.new(:day, "10:00", task) 

    assert job == %Job{frequency: {0, 10, :*, :*, :*}, task: task}
  end

  test "run/1 returns updated %Job{}", %{job_supervisor: job_supervisor} do
    task = fn -> :ok end
    job = Job.new(:day, task) 

    assert job.pid == nil 
    %Job{pid: pid} = Job.run(job, job_supervisor)
    assert pid != nil 
  end

  test "can_run/1 with an every minute job returns true" do
    task = fn -> :ok end
    job = Job.new(:minute, task) 

    assert true == Cronex.Job.can_run(job)
  end

  test "can_run/1 with an every hour job" do
    task = fn -> :ok end
    job = Job.new(:hour, task) 

    TestDateTime.set(%Cronex.DateTime{minute: 0})
    assert true == Cronex.Job.can_run(job)

    TestDateTime.set(%Cronex.DateTime{minute: 1})
    assert false == Cronex.Job.can_run(job)
  end

  test "can_run/1 with an every day job" do
    task = fn -> :ok end
    job = Job.new(:day, task) 

    TestDateTime.set(%Cronex.DateTime{hour: 0, minute: 0})
    assert true == Cronex.Job.can_run(job)

    TestDateTime.set(%Cronex.DateTime{hour: 0, minute: 1})
    assert false == Cronex.Job.can_run(job)

    TestDateTime.set(%Cronex.DateTime{hour: 1, minute: 0})
    assert false == Cronex.Job.can_run(job)

    TestDateTime.set(%Cronex.DateTime{hour: 1, minute: 1})
    assert false == Cronex.Job.can_run(job)
  end

  test "can_run/1 with an every week day job" do
    task = fn -> :ok end
    job = Job.new(:wednesday, task) 

    TestDateTime.set(%Cronex.DateTime{day_of_week: 3, hour: 0, minute: 0})
    assert true == Cronex.Job.can_run(job)

    TestDateTime.set(%Cronex.DateTime{day_of_week: 1, hour: 0, minute: 0})
    assert false == Cronex.Job.can_run(job)

    TestDateTime.set(%Cronex.DateTime{day_of_week: 3, hour: 1, minute: 0})
    assert false == Cronex.Job.can_run(job)
  end

  test "can_run/1 with an every month job" do
    task = fn -> :ok end
    job = Job.new(:month, task) 

    TestDateTime.set(%Cronex.DateTime{day: 1, hour: 0, minute: 0})
    assert true == Cronex.Job.can_run(job)

    TestDateTime.set(%Cronex.DateTime{day: 2, hour: 0, minute: 0})
    assert false == Cronex.Job.can_run(job)

    TestDateTime.set(%Cronex.DateTime{day: 1, hour: 1, minute: 0})
    assert false == Cronex.Job.can_run(job)
  end

  test "can_run/1 with an every year job" do
    task = fn -> :ok end
    job = Job.new(:year, task) 

    TestDateTime.set(%Cronex.DateTime{month: 1, day: 1, hour: 0, minute: 0})
    assert true == Cronex.Job.can_run(job)

    TestDateTime.set(%Cronex.DateTime{month: 2, day: 1, hour: 0, minute: 0})
    assert false == Cronex.Job.can_run(job)

    TestDateTime.set(%Cronex.DateTime{month: 1, day: 2, hour: 0, minute: 0})
    assert false == Cronex.Job.can_run(job)
  end
end
