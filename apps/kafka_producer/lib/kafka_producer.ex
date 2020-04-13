defmodule KafkaProducer do

  def write_event(event \\ %{}) do
    KafkaEx.produce(
      %KafkaEx.Protocol.Produce.Request{
        topic: "mw-first-topic",
        # partition: 0,
        required_acks: 1,
        messages: [
          %KafkaEx.Protocol.Produce.Message{value: Jason.encode!(event)}
        ]
      }
    )
  end
end
