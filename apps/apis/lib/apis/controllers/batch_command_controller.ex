defmodule Apis.BatchCommandController do
  use Apis, :controller

  require Logger

  @max_retries 5
  @sleep_between_tries_msecs 500

  def batch_process(conn, %{"bq_table_root" => bq_table_root} = _params) do
    Logger.log(:info, "POST Batch Command: #{inspect(bq_table_root)}")

    write_batch_process_event(bq_table_root)
    json(conn, %{result: :ok})
  end

  defp write_batch_process_event(bq_table_root),
    do: write_batch_process_event(bq_table_root, @max_retries, "")

  defp write_batch_process_event(bq_table_root, 0, last_error) do
    Logger.error(
      "write_batch_process_event: max_retries exceeded.  bq_table_root: #{inspect(bq_table_root)}, last_error: #{
        inspect(last_error)
      }"
    )
  end

  defp write_batch_process_event(bq_table_root, count, _last_error) do
    try do
      KafkaProducer.write_batch_process_event(bq_table_root)
    rescue
      error ->
        Process.sleep(@sleep_between_tries_msecs)
        write_batch_process_event(bq_table_root, count - 1, error)
    end
  end
end
