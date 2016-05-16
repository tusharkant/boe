defmodule Boe do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    poolboy_config = [
      {:name, {:local, pool_name()}},
      {:worker_module, Boe.Worker},
      {:size, 2},
      {:max_overflow, 10}
    ]

    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      # worker(Boe.Worker, [arg1, arg2, arg3]),
      :poolboy.child_spec(pool_name(), poolboy_config, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Boe.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def pool_name() do
    :boe_pool
  end
end
