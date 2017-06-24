defmodule Urlz.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok)
  end

  defp poolboy_config do
    [{:name, {:local, :worker}},
     {:worker_module, Urlz.Shortener},
     {:size, 2},
     {:max_overflow, 2}]
  end


  def init(:ok) do
    children = [
      :poolboy.child_spec(:worker, poolboy_config, []),
      supervisor(Urlz.CacheSupervisor, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
