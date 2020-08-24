defmodule News.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      #News.Repo,
      # Start the Telemetry supervisor
      NewsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: News.PubSub},
      # Start the Endpoint (http/https)
      NewsWeb.Endpoint,
      # Start a worker by calling: News.Worker.start_link(arg)
      # {News.Worker, arg}
      # {News.Aggregators.Nfl, []},
      {Mongo, [name: :mongo, database: "news", pool_size: 10]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: News.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    NewsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
