defmodule Urlz.ShortenerTest do
  use ExUnit.Case, async: true

  test "shortens a url" do
    {:ok, db}= Urlz.Shortener.start_link
    url =  "http://google.com/123"
    result = Urlz.Shortener.shorten(db, url)

    assert result
    assert result != url
    assert String.length(result) == 4
  end

  test "expand a shortened url" do
    {:ok, db }= Urlz.Shortener.start_link
    url =  "http://google.com/123"
    shortened_url = Urlz.Shortener.shorten(db, url)

    result = Urlz.Shortener.expand(db, shortened_url)
    assert result == url
  end
end
