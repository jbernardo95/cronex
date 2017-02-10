# Cronex

[![Travis Build](https://api.travis-ci.org/jbernardo95/cronex.svg?branch=master)](https://travis-ci.org/jbernardo95/cronex/)

A cron like system, built in Elixir, that you can mount in your supervision tree.

Cronex's DSL for adding cron jobs is inspired by [whenever](https://github.com/javan/whenever) Ruby gem.

## Installation

Add `cronex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:cronex, "~> 0.4.0"}]
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

    supervise(children, ...)
  end

  # ...
end
```

You can define as much schedulers as you want.

## Testing

Cronex comes with `Cronex.Test` module which provides helpers to test your cron jobs.

```elixir
defmodule MyApp.SchedulerTest do
  use ExUnit.Case
  use Cronex.Test

  test "every hour job is defined in MyApp.Scheduler" do
    assert_job_every :hour, in: MyApp.Scheduler 
  end

  test "every day job at 10:00 is defined in MyApp.Scheduler" do
    assert_job_every :day, at: "10:00", in: MyApp.Scheduler 
  end
end
```

## Documentation

The project documentation can be found [here](https://hexdocs.pm/cronex/api-reference.html).

## Roadmap

- [ ] Add support for different time zones
- [ ] Improve multi node support and control 

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jbernardo95/cronex.

## License

Cronex source code is licensed under the [MIT License](LICENSE.md).
