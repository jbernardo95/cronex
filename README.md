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

Cronex has two ways of working:

  1. **As an application**
    
    You can only have **one** scheduler using this option. 

    ```elixir
    # mix.exs
    def application do
      [applications: [:cronex]]
    end

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

  2. **As a module you can use in your supervision tree**

    You can define as much schedulers as you want with this option.

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

    # Your application supervisor
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

Cronex will gather jobs from the scheduler you defined and will run them at the expected time.

## Roadmap

- [ ] Extract error handling logic outside of cronex domain with a scheulder developers can use in their supervision trees
- [ ] Add how it works to readme
- [ ] More complex every statements (every 3 days, every 4 hours, etc…)
- [ ] Test helpers to test jobs ???
