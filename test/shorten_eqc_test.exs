defmodule ShortenerPropertyTest do
  use ExUnit.Case
  use EQC.ExUnit

  def string, do: utf8()

  @tag numtests: 10000
  property "shortens all strings" do
    forall s <- string() do
       ensure String.length(Urlz.Shortener.shorten_url(s)) > 0
      end
  end
end
