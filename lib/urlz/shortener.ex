defmodule Urlz.Shortener do

  @spec start_link() :: {:ok, pid} 
  def start_link do
    Agent.start_link(fn -> %{} end)
  end
  
  @spec shorten(pid, String.t) :: String.t
  def shorten(db, url) do
    shortened_url = 
      url
      |> :erlang.md5
      |> Base.encode16(case: :lower)
      |> String.slice(0..3)

    Agent.update(db, fn(urls) -> Map.put(urls, shortened_url, url) end)
    shortened_url
  end

  @spec expand(pid, String.t) :: String.t
  def expand(db, shortened_url) do
    Agent.get(db, fn(urls) -> Map.get(urls, shortened_url) end)
  end
end
