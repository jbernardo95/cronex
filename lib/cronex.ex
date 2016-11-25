defmodule Cronex do
  use Application
  use Cronex.Scheduler

  def start(_type, _args) do
    start_link
  end
end
