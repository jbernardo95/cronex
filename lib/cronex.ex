defmodule Cronex do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Cronex.Master, []),
      supervisor(Cronex.Supervisor, [])
    ]

    opts = [strategy: :one_for_one, name: Cronex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
