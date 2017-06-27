defmodule ApiPropertyTest do
  use ExUnit.Case
  use EQC.ExUnit
  use Plug.Test

  def string, do: utf8()

  @opts Urlz.Router.init([])

  @tag numtests: 10000
  property "shortens all strings" do
    forall s <- string() do
     implies s != "" do
        slug =
          conn(:post, "/", %{"url" => s})
          |> Urlz.Router.call(@opts).resp_body

        conn = conn(:get, slug)
        conn = Urlz.Router.call(conn, @opts)
        destination = conn.resp_body
        ensure destination == s
     end
    end
  end
end
