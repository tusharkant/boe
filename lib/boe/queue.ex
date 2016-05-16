defmodule Boe.Queue do
  @doc "Kicks the Listen method based on the atom :amqp or :beanstalkd"
  def connect(:beanstalk, host: host, port: port, tube: tube), do: {:beanstalk, host, port, tube}

  def connect(:amqp), do: {nil}
end
