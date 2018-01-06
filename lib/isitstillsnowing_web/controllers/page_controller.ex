defmodule IsitstillsnowingWeb.PageController do
  use IsitstillsnowingWeb, :controller


  alias Isitstillsnowing.Weather

  plug RemoteIp

  def index(conn, _params) do
    ip = Tuple.to_list(conn.remote_ip) |> Enum.join(".")
    # Inspecting for debugging
    {_status, weather_from_ip} = Weather.main(ip) |> IO.inspect

    render conn, "index.html", snowing: weather_from_ip.snowing
  end
end
