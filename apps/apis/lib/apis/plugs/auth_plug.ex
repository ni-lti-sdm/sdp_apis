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
    api_key = get_api_key(conn)
    case api_key_valid?(api_key) do
      :ok ->
        conn

      :unauthorized ->
        handle_unauthorized(conn)
    end
  end

  defp handle_unauthorized(conn) do
    conn
    |> send_resp(401, "Unauthorized")
    |> halt()
  end

  def get_api_key(conn) do
    header_apikey =
      Enum.find(conn.req_headers, fn {key, _} -> @http_header_api_key == String.downcase(key) end)

    case header_apikey do
      {_, api_key} -> api_key
      nil -> nil
    end
  end

  def api_key_valid?(@whitelisted_api_key), do: :ok
  def api_key_valid?(_), do: :unauthorized

end
