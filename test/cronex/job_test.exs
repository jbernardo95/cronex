defmodule Cronex.JobTest do
  use ExUnit.Case

  alias Cronex.Job

  describe "new/2" do
    test "returns a %Job{}" do
      task = fn -> IO.puts "Daily Task" end
      job = Job.new(:daily, task) 

      assert job == %Job{frequency: :daily, time: nil, task: task}
    end
  end

  describe "new/3" do
    test "returns a %Job{}" do
      task = fn -> IO.puts "Daily Task" end
      job = Job.new(:daily, "10:00", task) 

      assert job == %Job{frequency: :daily, time: "10:00", task: task}
    end
  end

  describe "run/1" do
    test "returns {:ok, pid}" do
      task = fn -> IO.puts "Daily Task" end
      job = Job.new(:daily, task) 

      assert {:ok, _pid} = Job.run(job)
    end
  end
end
