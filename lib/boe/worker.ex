defmodule Boe.Worker do
  use GenServer

  require Logger

  def start_link([]) do
    :gen_server.start_link(__MODULE__, [], [])
  end

  def init(state) do
    {:ok, state}
  end

  def handle_call(data, from, state) do
    :timer.sleep(100)
    # result = Deadpool.Squarer.square(data)
    # IO.puts "Worker Reports: #{data} * #{data} = #{result}"
    # {:reply, [result], state}
    {tube, beanstalk_pid} = data
    IO.inspect data
    IO.inspect from
    IO.inspect state
    # ElixirTalk.watch(beanstalk_pid, tube)
    # IO.inspect ElixirTalk.list_tubes_watched(beanstalk_pid)
    spawn( fn() ->
      Boe.Execute.kick(tube)
    end )

    {:reply, [data], state}
  end

  def consume(pid, value) do
    :gen_server.call(pid, value)
  end
end
