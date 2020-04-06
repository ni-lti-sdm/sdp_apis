defmodule Apis.NewFilesController do
  use Apis, :controller

  require Logger

  def new_file(conn, params) do
    Logger.log(:info, "POST New File: #{inspect params}")
    KafkaProducer.write_event(params)
    json(conn, %{result: :ok})
  end

end
