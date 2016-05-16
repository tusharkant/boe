defmodule Boe.CLI do
  @moduledoc """
  Handle the command line parsing and the dispatch to the various functions that
  includes connecting and consuming queues/tubes from AMQP/Beanstalkd
  """

  require Logger

  @beanstalk    "beanstalk"
  @amqp         "amqp"
  @default_tube ["default"]

  def main(argv) do
    argv
      |> parse_args
      |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :help.

  Otherwise it is a beanstalkHost, beanstalkPort and (optionally) beanstalkTube,

  beanstalkTube is 'default' if not passed, to listen on all tubes pass 'all'
  or if you want to listen on some specific tubes then pass 'tube1, tube2'

  Return a tuple or `:help` if help was given.
  """
  def parse_args(argv) do
    parse =
      OptionParser.parse argv,
        switches: [ help: :boolean ],
        aliases:  [ h:    :help    ]

    case parse do
      { [ help: true ], _, _ }
        -> :help

      { [ beanstalkHost: beanstalkHost, beanstalkPort: beanstalkPort, beanstalkTube: beanstalkTube ], _, _ }
        -> { @beanstalk, beanstalkHost, beanstalkPort, String.split(beanstalkTube, ",") }

      { [ beanstalkHost: beanstalkHost, beanstalkPort: beanstalkPort], _, _ }
        -> { @beanstalk, beanstalkHost, beanstalkPort, @default_tube }

      _ -> :help
    end
  end

  def process(:help) do
    IO.puts """
    Usage:
    For Beanstalk:
    ./boe --beanstalkHost <beanstalkHost> --beanstalkPort <beanstalkPort> --beanstalkTube [ beanstalkTube | #{@default_tube} ]

    Options:
    --help           Show this help message.
    --beanstalkHost  Host to connect to beanstalkd
    --beanstalkPort  Port at which beanstalkd is listening
    --beanstalkTube  Tube(s) to consume, by default it will be 'default'
                     for all pass 'all', for multiple pass 'tube1, tube2'

    """
    System.halt(0)
  end

  def process({ queue, beanstalkHost, beanstalkPort, beanstalkTube }) when queue == @beanstalk do
    beanstalk = Boe.Queue.connect(:beanstalk, host: beanstalkHost, port: beanstalkPort, tube: beanstalkTube)
    Boe.Listener.start(beanstalk)
  end

  def process({ queue, amqpHost, amqpPort, amqpQueue }) when queue == @amqp do
    # @todo add the functionality for AMQP here
  end
end
