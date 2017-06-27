defmodule Urlz.Shortener do
  use GenServer

  @type url :: %Urlz.Url{destination: String.t, slug: String.t} | %Urlz.Url{destination: nil, slug: nil}

  # client

  @spec expand(pid, String.t) :: url
  def expand(pid, shortened_url) do
    GenServer.call(pid, {:expand, shortened_url})
  end

  @spec shorten(pid, String.t) :: url
  def shorten(pid, url) do
    GenServer.call(pid, {:shorten, url})
  end

  # server

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, [])
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_call({:shorten, url}, from, state) do
    shortened_url = shorten_url(url)
    result = Urlz.Cache.set(shortened_url, url)

    {:reply, result, state}
  end

  def handle_call({:expand, url}, from, state) do
    result = Urlz.Cache.get(url)
    {:reply, result, state}
  end


  # business logic

  @spec shorten_url(String.t) :: String.t
  def shorten_url(url) do
    url
    |> :erlang.md5
    |> Base.encode16(case: :lower)
    |> String.slice(0..3)
  end
end
