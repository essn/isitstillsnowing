defmodule Isitstillsnowing.Weather do
  alias Isitstillsnowing.IpInfo

  def main(ip) do
   ip
   |> get_geo_info
   |> get_weather
   |> calculate_is_snowing
  end

  defp get_geo_info(ip) do
    {:ok, %HTTPoison.Response{body: body}} =
      HTTPoison.get("http://ip-api.com/json/#{ip}")

    with %{"zip" => zip, "lat" => lat, "lon" => lon} <- Poison.decode!(body)
    do
      {:ok, %IpInfo{zip: zip, lat: lat, lon: lon, ip: ip}}
    else
      _ -> {:error, %IpInfo{ip: ip}}
    end
  end

  defp get_weather(err = {:error, _}), do: err
  defp get_weather({:ok, ip_info = %IpInfo{}}) do
    params = build_params(ip_info)

    {:ok, %HTTPoison.Response{body: body}} =
      HTTPoison.get("api.openweathermap.org/data/2.5/weather?#{params}")

    with %{"weather" => weather } <- Poison.decode!(body)
    do
      {:ok, %IpInfo{ip_info | weather_list: weather}}
    else
      _ -> {:error, ip_info}
    end
  end

  defp build_params(ip_info = %IpInfo{}) do
    params = case ip_info do
      %IpInfo{lat: nil}
        -> "zip=#{ip_info.zip}"
      %IpInfo{lon: nil}
        -> "zip=#{ip_info.zip}"
      _
        -> "lat=#{ip_info.lat}&lon=#{ip_info.lon}"
    end

    app_id = Application.get_env(:isitstillsnowing, :openweather_api_key)

    "#{params}&APPID=#{app_id}"
  end

  defp calculate_is_snowing(err = {:error, _}), do: err
  defp calculate_is_snowing({:ok, ip_info = %IpInfo{}}) do
    types = Enum.map ip_info.weather_list, fn(item) -> item["main"] end

    {:ok, %IpInfo{ip_info | snowing: Enum.member?(types, "Snow")}}
  end
end
