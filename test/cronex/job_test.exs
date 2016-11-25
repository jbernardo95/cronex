defmodule Cronex.JobTest do
  use ExUnit.Case

  alias Cronex.Job

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
end
