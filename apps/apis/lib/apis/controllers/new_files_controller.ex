defmodule Apis.NewFilesController do
  use Apis, :controller

  require Logger

  @max_retries 5
  @sleep_between_tries_msecs 500

  def new_file(conn, params) do
    Logger.log(:info, "POST New File: #{inspect(params)}")

    write_file_arrival_event(params)
    json(conn, %{result: :ok})
  end

  defp write_file_arrival_event(params), do: write_file_arrival_event(params, @max_retries, "")

  defp write_file_arrival_event(params, 0, last_error) do
    Logger.error(
      "write_file_arrival_event: max_retries exceeded.  params: #{inspect(params)}, last_error: #{
        inspect(last_error)
      }"
    )
  end

  defp write_file_arrival_event(params, count, _last_error) do
    try do
      KafkaProducer.write_file_arrival_event(params)
    rescue
      error ->
        Process.sleep(@sleep_between_tries_msecs)
        write_file_arrival_event(params, count - 1, error)
    end
  end
end
