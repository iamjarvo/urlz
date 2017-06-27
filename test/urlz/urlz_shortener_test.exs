defmodule Urlz.ShortenerTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, shortner} = Urlz.Shortener.start_link(:ok)
    {:ok, shortner: shortner}
  end

  test "shortens a url", %{shortner: shortner} do
    url =  "http://google.com/123"
    result = Urlz.Shortener.shorten(shortner, url)

    assert result
    assert result != url
    assert String.length(result) == 4
  end

  test "expand a shortened url", %{shortner: shortner} do
    url =  "http://google.com/123"
    shortened_url = Urlz.Shortener.shorten(shortner, url)

    result = Urlz.Shortener.expand(shortner, shortened_url)
    assert result.destination == url
  end
end
