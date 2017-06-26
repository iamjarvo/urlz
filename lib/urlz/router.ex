defmodule Urlz.Router do
  use Plug.Router

  plug :match
  plug :dispatch
  plug Plug.Parsers, parsers: [:json],
                     pass:  ["text/*"],
                     json_decoder: Poison

  get "/:id" do
    p = Map.get(conn, :params)["id"]

    case result = :poolboy.transaction(:worker, fn(w) -> Urlz.Shortener.expand(w, p) end) do
      [] ->
        send_resp(conn, 404, "Gone fishing")
      _ ->
        send_resp(conn, 200, result)
    end
  end

  post "/" do
    {:ok, body, _} = Plug.Conn.read_body(conn)
    {:ok, %{"url" => url}} = Poison.decode(body)

    result = :poolboy.transaction(:worker, fn(w) -> Urlz.Shortener.shorten(w, to_string(url)) end)
    send_resp(conn, 201, result)
  end

  match _ do
    send_resp(conn, 404, "At QConNY")
  end
end
