defmodule HabitTracker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      HabitTrackerWeb.Telemetry,
      HabitTracker.Repo,
      {DNSCluster, query: Application.get_env(:habit_tracker, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: HabitTracker.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: HabitTracker.Finch},
      # Start a worker by calling: HabitTracker.Worker.start_link(arg)
      # {HabitTracker.Worker, arg},
      # Start to serve requests, typically the last entry
      HabitTrackerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HabitTracker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HabitTrackerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
