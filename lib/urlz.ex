defmodule Urlz do
  use Application

  def start(_type, _args) do
    Urlz.Supervisor.start_link
  end
end
