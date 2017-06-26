defmodule Urlz.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  defp poolboy_config do
    [{:name, {:local, :worker}},
     {:worker_module, Urlz.Shortener},
     {:size, 100},
     {:max_overflow, 0}]
  end


  def init(:ok) do
    children = [
      :poolboy.child_spec(:worker, poolboy_config(), []),
      supervisor(Urlz.CacheSupervisor, []),
      Plug.Adapters.Cowboy.child_spec(:http, Urlz.Router, [], [port: Application.get_env(:urlz, :port, 4001), acceptors: 1000])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
