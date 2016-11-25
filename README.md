# Cronex

[![Travis Build](https://api.travis-ci.org/jbernardo95/cronex.svg?branch=master)](https://travis-ci.org/jbernardo95/cronex/)

A cron like system built with elixir, inspired by [whenever](https://github.com/javan/whenever) ruby gem.

## Installation

Add `cronex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:cronex, "~> 0.1.1"}]
end
```

Then run `mix deps.get` to get the package.

## Getting started

Cronex makes it really easy and intuitive to schedule cron like jobs.

You use the `Cronex.Scheduler` module to define a scheduler and add jobs to it.

Cronex will gather jobs from the scheduler you defined and will run them at the expected time.

```elixir
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

    supervise(children, strategy: :one_for_one)
  end

  # ...
end
```

You can define as much schedulers as you want.

## Roadmap

- [ ] Add how it works to readme
- [ ] More complex every statements (every 3 days, every 4 hours, etc…)
- [ ] Test helpers to test jobs ???
