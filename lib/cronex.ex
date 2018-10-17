defmodule Cronex do
  @moduledoc """
  This is Cronex main module.

  ## Getting started

  Cronex makes it really easy and intuitive to schedule cron like jobs.

  You use the `Cronex.Scheduler` module to define a scheduler and add jobs to it.

  Cronex will gather jobs from the scheduler you defined and will run them at the expected time.

      # Somewhere in your application define your scheduler
      defmodule MyApp.Scheduler do
        use Cronex.Scheduler

        every :hour do
          IO.puts "Every hour job"
        end

        every :day, at: "10:00" do
          IO.puts "Every day job at 10:00"
        end
      end

      # Start scheduler with start_link
      MyApp.Scheduler.start_link

      # Or add it to your supervision tree
      defmodule MyApp.Supervisor do
        use Supervisor

        # ...

        def init(_opts) do
          children = [
            # ...
            supervisor(MyApp.Scheduler, [])
            # ...
          ]

          supervise(children, ...)
        end

        # ...
      end
  """
end
