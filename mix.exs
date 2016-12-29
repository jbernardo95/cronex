defmodule Cronex.Mixfile do
  use Mix.Project

  def project do
    [app: :cronex,
     version: "0.3.0",

     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,

     deps: deps(),
     package: package(),

     name: "Cronex",
     description: "A cron like system built in Elixir, that you can mount in your supervision tree",
     source_url: "https://github.com/jbernardo95/cronex",
     homepage_url: "https://github.com/jbernardo95/cronex",
     docs: [main: "readme",
            extras: ["README.md", "CHANGELOG.md"]]]
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
