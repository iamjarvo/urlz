defmodule Urlz.ShortenerTest do
  use ExUnit.Case, async: true

  test "shortens a url" do
    url =  "http://google.com/123"
    result = Urlz.Shortener.shorten(url)

    assert result
    assert result != url
    assert String.length(result) == 4
  end
end
