defmodule TimeManagerApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TimeManagerAppWeb.Telemetry,
      TimeManagerApp.Repo,
      {DNSCluster, query: Application.get_env(:timemanagerapp, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TimeManagerApp.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TimeManagerApp.Finch},
      # Start a worker by calling: TimeManagerApp.Worker.start_link(arg)
      # {TimeManagerApp.Worker, arg},
      # Start to serve requests, typically the last entry
      TimeManagerAppWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TimeManagerApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TimeManagerAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
