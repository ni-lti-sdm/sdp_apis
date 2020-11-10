defmodule ElixirLib.KafkaEx.Brokers do
  def brokers() do
    [{System.get_env("KAFKA_EX_HOST"), String.to_integer(System.get_env("KAFKA_EX_PORT"))}]
  end
end
