defmodule Urlz.Router do
  use Plug.Router

  plug :match
  plug :dispatch
  plug Plug.Parsers, parsers: [:json],
                     pass:  ["text/*"],
                     json_decoder: Poison

  get "/:id" do
    %Urlz.Url{destination: destination, slug: slug} = :poolboy.transaction(:shortener_pool, fn(w) -> Urlz.Shortener.expand(w, id) end)
    case slug do
      nil ->
        send_resp(conn, 404, "Gone fishing")
      _ ->
        send_resp(conn, 200, slug)
    end
  end

  post "/" do
    {:ok, body, _} = Plug.Conn.read_body(conn)

    case Poison.decode(body) do
      {:ok, %{"url" => url}} ->
        result = :poolboy.transaction(:shortener_pool, fn(w) -> Urlz.Shortener.shorten(w, to_string(url)) end)
        send_resp(conn, 201, result)
      _ ->
        send_resp(conn, 200, "Meh")
    end
  end

  match _ do
    send_resp(conn, 404, "At QConNY")
  end
end
