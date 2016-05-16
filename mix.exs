defmodule Boe.Mixfile do
  use Mix.Project

  def project do
    [app: :boe,
     version: "0.0.1",
     name: "Boe",
     author: "Tushar Kant <tushar.kant@kayako.com>",
     elixir: "~> 1.2",
     escript: escript_config,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :poolboy],
     mod: {Boe, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      { :elixir_talk, git: "https://github.com/tusharkant/elixir_talk", branch: "master", app: false },
      { :poolboy, "~> 1.5" },
      { :logger_file_backend, git: "https://github.com/onkel-dirtus/logger_file_backend", branch: "master", app: false}
    ]
  end

  defp escript_config do
    [ main_module: Boe.CLI ]
  end
end
