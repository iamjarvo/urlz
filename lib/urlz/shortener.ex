defmodule Urlz.Shortener do
  @spec shorten(String.t) :: String.t
  def shorten(url) do
    url
    |> :erlang.md5
    |> Base.encode16(case: :lower)
    |> String.slice(0..3)
  end
end
