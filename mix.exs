defmodule Saxmerl.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project() do
    [
      app: :saxmerl,
      version: @version,
      elixir: "~> 1.6",
      description: description(),
      deps: deps(),
      package: package(),
      name: "Saxmerl",
      docs: docs()
    ]
  end

  def application(), do: []

  defp deps() do
    [
      {:saxy, "~> 1.2"},
      {:benchee, "~> 1.0", only: :dev},
      {:sweet_xml, "~> 0.6", only: [:dev, :test]}
    ]
  end

  defp description() do
    """
    Saxmerl is a fast and memory efficient parser in Elixir that parses XML documents into `:xmerl` format.
    """
  end

  defp package() do
    [
      maintainers: ["Cẩm Huỳnh"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/qcam/saxmerl"}
    ]
  end

  defp docs() do
    [
      main: "Saxmerl",
      source_ref: "v#{@version}",
      source_url: "https://github.com/qcam/saxmerl"
    ]
  end
end
