# Cronex

[![Travis Build](https://api.travis-ci.org/jbernardo95/cronex.svg?branch=master)](https://travis-ci.org/jbernardo95/cronex/)

A cron like system built with elixir.

## Installation

  1. Add `cronex` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:cronex, "~> 0.1.1"}]
    end
    ```

  2. Ensure `cronex` is started before your application:

    ```elixir
    def application do
      [applications: [:cronex]]
    end
    ```

## Getting started

Cronex makes it really easy and intuitive to schedule cron like jobs.

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

# In your config/config.exs file
config :cronex, scheduler: MyApp.Scheduler
```

Cronex will gather jobs from the scheduler you defined and will run them at the expected time.
