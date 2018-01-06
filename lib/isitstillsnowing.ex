defmodule Isitstillsnowing do
  @moduledoc """
  Isitstillsnowing keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  def main(ip) do
    ip
    |> get_location
  end

  def get_location(ip) do
    decoded_body =
      HTTPoison.get("http://ip-api.com/json#{ip}").body
      |> Poison.decode
  end
end
