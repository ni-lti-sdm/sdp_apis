defmodule KafkaProducer do
  require Logger

  def write_file_arrival_event(event \\ %{}) do
    Logger.log(
      :info,
      "KafkaProducer.write_file_arrival_event() writing event to ingest-phase-1 & ingest-tdr topics #{
        inspect(event)
      }"
    )

    spawn(fn ->
      KafkaEx.produce(
        %KafkaEx.Protocol.Produce.Request{
          topic: "ingest-phase-1",
          # partition: 0,
          required_acks: 1,
          messages: [
            %KafkaEx.Protocol.Produce.Message{value: Jason.encode!(event)}
          ],
          timeout: 60_000
        },
        timeout: 120_000
      )
    end)

    spawn(fn ->
      KafkaEx.produce(
        %KafkaEx.Protocol.Produce.Request{
          topic: "ingest-tdr",
          required_acks: 1,
          messages: [
            %KafkaEx.Protocol.Produce.Message{value: Jason.encode!(event)}
          ],
          timeout: 60_000
        },
        timeout: 120_000
      )
    end)
  end

  def write_batch_process_event(bq_table_root) do
    Logger.log(
      :info,
      "KafkaProducer.write_batch_process_event() writing event to ingest-batch-metadata bq_table_root #{
        inspect(bq_table_root)
      }"
    )

    spawn(fn ->
      KafkaEx.produce(
        %KafkaEx.Protocol.Produce.Request{
          topic: "ingest-batch-metadata",
          # partition: 0,
          required_acks: 1,
          messages: [
            %KafkaEx.Protocol.Produce.Message{
              value: Jason.encode!(%{"bq_table_root" => bq_table_root})
            }
          ],
          timeout: 60_000
        },
        timeout: 120_000
      )
    end)
  end
end
