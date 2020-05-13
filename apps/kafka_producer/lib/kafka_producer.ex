defmodule KafkaProducer do
  require Logger

  def write_event(event \\ %{}) do
    Logger.log(
      :info,
      "KafkaProducer.write_event() writing event to ingest-phase-1 topic #{inspect(event)}"
    )

    spawn(fn ->
      KafkaEx.produce(%KafkaEx.Protocol.Produce.Request{
        topic: "ingest-phase-1",
        # partition: 0,
        required_acks: 1,
        messages: [
          %KafkaEx.Protocol.Produce.Message{value: Jason.encode!(event)}
        ]
      })
    end)

    spawn(fn ->
      KafkaEx.produce(%KafkaEx.Protocol.Produce.Request{
        topic: "ingest-tdr",
        required_acks: 1,
        messages: [
          %KafkaEx.Protocol.Produce.Message{value: Jason.encode!(event)}
        ]
      })
    end)
  end
end
