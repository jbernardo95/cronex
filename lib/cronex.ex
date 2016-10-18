defmodule Cronex do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Cronex.Master, [nil, [name: :cronex_master]]),
      supervisor(Cronex.Supervisor, [nil, [name: :cronex_supervisor]])
    ]

    opts = [strategy: :one_for_one, name: Cronex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
