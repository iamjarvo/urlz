defmodule Urlz.Cache do
  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [{:ets_table_name, :urlz}], name: __MODULE__)
  end

  def init(args) do
    [{:ets_table_name, ets_table_name}] = args
    :ets.new(ets_table_name, [:named_table, :set, :private, read_concurrency: true])
    {:ok, %{ets_table_name: ets_table_name}}
  end 

  def set(slug, value) do
    GenServer.call(__MODULE__, {:set, slug, value})
  end

  @spec get(String.t) :: %Urlz.Url{destination: String.t, slug: String.t} | %Urlz.Url{destination: nil, slug: nil}
  def get(slug) do
    case GenServer.call(__MODULE__, {:get, slug}) do
      [{slug, destination}] ->
        %Urlz.Url{destination: destination, slug: slug}
      _ ->
        %Urlz.Url{}
    end
  end

  def handle_call({:get, slug}, _from, state) do
    %{ets_table_name: ets_table_name} = state

    result = :ets.lookup(ets_table_name, slug)
    {:reply, result, state}
  end

  def handle_call({:set, slug, value}, _from, state) do
    %{ets_table_name: ets_table_name} = state
    true = :ets.insert(ets_table_name, {slug, value})
    {:reply, slug, state}
  end
end
