defmodule IsitstillsnowingWeb.PageController do
  use IsitstillsnowingWeb, :controller

  def index(conn, _params) do
    ip = Tuple.to_list(conn.remote_ip) |> Enum.join(".")

    {:ok, %HTTPoison.Response{body: body}} =
      HTTPoison.get("http://ip-api.com/json/#{ip}")

    %{"zip" => zip} = Poison.decode!(body)

    params = "zip=#{zip}&APPID=#{Application.get_env(:isitstillsnowing, :openweather_api_key)}"

    {:ok, %HTTPoison.Response{body: body}} =
      HTTPoison.get("api.openweathermap.org/data/2.5/weather?#{params}")

    snow_description = Enum.find Poison.decode!(body)["weather"], fn m ->
      m["main"] == "Snow"
    end

    snowing = case snow_description do
      nil
        -> false
      _
        -> true
    end

    render conn, "index.html", snowing: snowing
  end
end
