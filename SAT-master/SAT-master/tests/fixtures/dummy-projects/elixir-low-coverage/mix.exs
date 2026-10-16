defmodule App.MixProject do
  use Mix.Project

  def project do
    [app: :app, version: "0.1.0", elixir: "~> 1.14", deps: deps(), test_coverage: [summary: [threshold: 0]]]
  end

  defp deps do
    [{:credo, "~> 1.7", only: [:dev, :test], runtime: false}]
  end
end
