defmodule Apis.AuthPlug do
  @moduledoc """
  A plug for authenticating all requests into sdp_apis
  """
  @behaviour Plug

  import Plug.Conn

  require Logger

  @http_header_api_key "x-ni-api-key"
  @whitelisted_api_key "uiq9cfvp7fMis2I/eWg6NyEZ2IfigsjlkZ69WibvXztoItSTeo3F4ZjVsZcrxcjo"


  def init(_opts) do
    []
  end

  def call(conn, _opts) do
    api_key_valid?(conn, get_api_key(conn))
  end

  defp api_key_valid?(conn, @whitelisted_api_key) do
    conn
  end

  defp api_key_valid?(conn, _) do
    conn
    |> send_resp(401, "Unauthorized")
    |> halt()
  end

  defp get_api_key(conn) do
    header_apikey =
      Enum.find(conn.req_headers, fn {key, _} -> @http_header_api_key == String.downcase(key) end)

    case header_apikey do
      {_, api_key} -> api_key
      nil -> nil
    end
  end

end
