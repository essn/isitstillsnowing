defmodule IsitstillsnowingWeb.PageController do
  use IsitstillsnowingWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
