defmodule Boe.Execute do
  def kick(tube) do
    # ElixirTalk.use(beanstalk_pid, tube)
    { :ok, pid } = ElixirTalk.connect('127.0.0.1', 11300)
    { :reserved, job_id, { job_size, job_packet } } = ElixirTalk.reserve(pid)
    IO.puts "Listing Job (IF ANY)"
    IO.inspect job_packet
    ElixirTalk.delete(pid, job_id)
    kick(tube)
  end
end
