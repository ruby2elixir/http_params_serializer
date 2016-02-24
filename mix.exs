defmodule HttpParamsSerializer.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [app: :http_params_serializer,
     version: @version,
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package,
     docs: [extras: ["README.md"]],
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
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
      {:ex_spec, "~> 1.0", only: :test},
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:earmark, "~> 0.2", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev},
    ]
  end

  defp package do
    [
     maintainers: ["Roman Heinrich"],
     licenses: ["MIT License"],
     description: "A small library to serialize deeply nested datastructures into HTTP parameters that most backends do understand",
     links: %{
       github: "https://github.com/ruby2elixir/http_params_serializer",
       docs: "http://hexdocs.pm/http_params_serializer/#{@version}/"
     }
    ]
  end
end
