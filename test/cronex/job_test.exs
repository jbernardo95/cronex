defmodule Cronex.JobTest do
  use ExUnit.Case

  alias Cronex.Job

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

  test "run/1 returns updated %Job{}" do
    task = fn -> :ok end
    job = Job.new(:day, task) 

    assert job.pid == nil 
    %Job{pid: pid} = Job.run(job)
    assert pid != nil 
  end

  test "can_run/1 with an every minute job returns true" do
    task = fn -> :ok end
    job = Job.new(:minute, task) 

    assert true == Cronex.Job.can_run(job)
  end
end
