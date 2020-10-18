defmodule Saxmerl.MixProject do
  use Mix.Project

  def project() do
    [
      app: :saxmerl,
      version: "0.1.0",
      elixir: "~> 1.6",
      deps: deps()
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
end
