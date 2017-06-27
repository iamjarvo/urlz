defmodule Urlz.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  defp poolboy_config do
    [{:name, {:local, :shortener_pool}},
     {:worker_module, Urlz.Shortener},
     {:size, 100},
     {:max_overflow, 100}]
  end

  def init(:ok) do
    port = Application.get_env(:urlz, :port, 4001)
    children = [
      :poolboy.child_spec(:shortener_pool, poolboy_config(), []),
      supervisor(Urlz.CacheSupervisor, []),
      Plug.Adapters.Cowboy.child_spec(:http, Urlz.Router, [], [port: port, acceptors: 100])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
