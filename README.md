# Cronex

[![Travis Build](https://api.travis-ci.org/jbernardo95/cronex.svg?branch=master)](https://travis-ci.org/jbernardo95/cronex/)

A cron like system built with elixir.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `cronex` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:cronex, "~> 0.1.0"}]
    end
    ```

  2. Ensure `cronex` is started before your application:

    ```elixir
    def application do
      [applications: [:cronex]]
    end
    ```

