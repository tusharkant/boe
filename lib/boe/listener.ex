defmodule Boe.Listener do
  require Logger

  def start({:beanstalk, host, port, tube}) when tube == ["all"] do
    Logger.debug "Trying to connect to beanstalkd with host:#{host} port:#{port}"
    {:ok, pid} = beanstalk_connect(host, port)
    # Worker counts : 2 workers per tube
    # @todo make it acceptable via cli
    look_for_new_tubes(pid, [], 2, [])
  end

  def start({:beanstalk, host, port, tube}) when is_list(tube) do
    Logger.debug "Trying to connect to beanstalkd with host:#{host} port:#{port}"
    {:ok, pid} = beanstalk_connect(host, port)
  end

  # def look_for_new_tubes(pid, tubes, num_worker, state) when state == tubes and length(tubes) != 0 do
  #   Logger.debug "In first part of look_for_new_tubes"
  #   :timer.sleep(2000)
  #   look_for_new_tubes(pid, ElixirTalk.list_tubes(pid), num_worker, state)
  # end

  def look_for_new_tubes(pid, tubes, num_worker, state) do
    new_tubes = ElixirTalk.list_tubes(pid)
    if new_tubes != tubes do
      Logger.debug "New Tubes Joined In: "
      Logger.debug new_tubes
      read_tube_list(new_tubes -- tubes, pid)
    end

    :timer.sleep(2000)

    look_for_new_tubes(pid, new_tubes, num_worker, new_tubes ++ tubes)
  end

  # Private methods goes here

  defp beanstalk_connect(host, port) do
    Logger.debug "In beanstalkd connector host:#{host} port:#{port}"
    # returns {:ok, pid}
    ElixirTalk.connect(String.to_char_list(host), String.to_integer(port))
  end

  defp tube_watch(x, beanstalk_pid) do
    Logger.debug "Tube came in to poolboy: " <> x
    :poolboy.transaction(
      Boe.pool_name(),
      fn(pid) -> Boe.Worker.consume(pid, { x, beanstalk_pid }) end,
      :infinity
    )
  end

  defp read_tube_list([head | tail], beanstalk_pid) do
    spawn( fn() ->
      tube_watch(head, beanstalk_pid)
    end )

    # Call recursively till the list becomes empty
    read_tube_list(tail, beanstalk_pid)
  end

  defp read_tube_list([], beanstalk_pid) do
    # do nothing when the tube list is empty
    Logger.debug "Consumed all beanstalkd tubes!"
  end

  # defp loop(tubes) do
  #   IO.puts "Looping"

  #   receive do
  #     {:ok, pid} ->
  #       IO.puts "Received first: " <> pid
  #     loop(pid)
  #     {:second, message} ->
  #       IO.puts "Received second: " <> message
  #     loop(pid)
  #   end
  # end
end
