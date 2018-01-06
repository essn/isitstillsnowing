defmodule IsitstillsnowingWeb.PageController do
  use IsitstillsnowingWeb, :controller

  alias Isitstillsnowing.Weather

  plug RemoteIp

  def index(conn, _params) do
    ip = Tuple.to_list(conn.remote_ip) |> Enum.join(".")
    {_status, weather_from_ip} = Weather.main(ip)

    render conn, "index.html", snowing: weather_from_ip.snowing
  end
end
