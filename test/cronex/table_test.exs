defmodule Cronex.TableTest do
  use ExUnit.Case

  alias Cronex.Job

  describe "add_job/1" do
    test "returns :ok" do
      task = fn -> IO.puts "Daily Task" end
      job = Job.new(:daily, task) 

      assert :ok == Cronex.Table.add_job(job)
    end
  end
end
