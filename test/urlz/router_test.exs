defmodule Urlz.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts Urlz.Router.init([])

  test "returns Gone Fishing" do
    conn = conn(:get, "does-not-exist")

    conn = Urlz.Router.call(conn, @opts)

    assert conn.status == 404
    assert conn.resp_body == "Gone fishing"
  end
end
