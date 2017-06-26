defmodule Urlz.Shortener do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, [])
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_call({:shorten, url}, from, state) do
    shortened_url = 
      url
      |> :erlang.md5
      |> Base.encode16(case: :lower)
      |> String.slice(0..3)

    result = Urlz.Cache.set(shortened_url, url)
    {:reply, "Hello from #{self |> :erlang.pid_to_list} | #{shortened_url}", state}    
  end

  def handle_call({:expand, url}, from, state) do
    result = Urlz.Cache.get(url)
    {:reply, "Hello from #{self |> :erlang.pid_to_list} | #{result}", state}    
  end

  def shorten(pid, url) do
    # shortened_url = 
    #   url
    #   |> :erlang.md5
    #   |> Base.encode16(case: :lower)
    #   |> String.slice(0..3)


    # Urlz.Cache.set(shortened_url, url)
    # shortened_url
    GenServer.call(pid, {:shorten, url})
  end

  @spec shorten(String.t) :: String.t
  def shorten(url) do
    shortened_url = 
      url
      |> :erlang.md5
      |> Base.encode16(case: :lower)
      |> String.slice(0..3)


    Urlz.Cache.set(shortened_url, url)
    shortened_url
  end

  @spec expand(String.t) :: String.t
  def expand(shortened_url) do
    Urlz.Cache.get(shortened_url)
  end

  @spec expand(String.t) :: String.t
  def expand(pid, shortened_url) do
    Urlz.Cache.get(shortened_url)
  end
end
# defmodule Urlz.Shortener do

#   @spec shorten(String.t) :: String.t
#   def shorten(url) do
#     shortened_url = 
#       url
#       |> :erlang.md5
#       |> Base.encode16(case: :lower)
#       |> String.slice(0..3)

#     Urlz.Cache.set(shortened_url, url)
#     shortened_url
#   end

#   @spec expand(String.t) :: String.t
#   def expand(shortened_url) do
#     Urlz.Cache.get(shortened_url)
#   end
# end

