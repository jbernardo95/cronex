defmodule Cronex.Mixfile do
  use Mix.Project

  def project do
    [app: :cronex,
     version: "0.2.0",

     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,

     deps: deps(),
     package: package(),

     name: "Cronex",
     description: "A cron like system built with elixir",
     source_url: "https://github.com/jbernardo95/cronex"]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:ex_doc, "~> 0.14", only: :dev}]
  end

  def package do
    [maintainers: ["jbernardo95"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/jbernardo95/cronex"}]
  end
end
