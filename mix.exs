defmodule ExAdvent.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_advent,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:benchfella, "~> 0.3.0"}
    ]
  end
end
