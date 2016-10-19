defmodule Cronex.MasterTest do
  use ExUnit.Case

  alias Cronex.Job

  setup do
    Cronex.Master.start_link
    Cronex.Supervisor.start_link
    {:ok, []}
  end

  describe "add_job/1" do
    test "returns slave process" do
      empty_job = %Job{}

      assert {:ok, pid} = Cronex.Master.add_job(empty_job)
      assert Process.alive?(pid)
    end
  end
end
