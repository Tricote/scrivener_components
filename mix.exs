defmodule ScrivenerComponents.MixProject do
  use Mix.Project

  @version "0.1.0"
  def project do
    [
      app: :scrivener_components,
      version: @version,
      elixir: "~> 1.16",
      name: "scrivener_components",
      source_url: "https://github.com/Tricote/scrivener_components",
      homepage_url: "https://github.com/Tricote/scrivener_components",
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: "Phoenix pagination components for Scrivener",
      docs: [
        main: Scrivener.Components,
        readme: "README.md"
      ],
      package: package(),
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:scrivener, "~> 2.0"},
      {:phoenix_html, "~> 4.0"},
      {:phoenix_live_view, "~> 0.20.2"},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["Thibaut Decaudain"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/Tricote/scrivener_components"}
    ]
  end

  defp aliases do
    [publish: ["hex.publish", "hex.publish docs", "tag"], tag: &tag_release/1]
  end

  defp tag_release(_) do
    Mix.shell().info("Tagging release as #{@version}")
    System.cmd("git", ["tag", "-a", "v#{@version}", "-m", "v#{@version}"])
    System.cmd("git", ["push", "--tags"])
  end
end
