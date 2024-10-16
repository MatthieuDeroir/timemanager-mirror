defmodule TimeManagerAppWeb.LogJSON do
  alias TimeManagerApp.Logs.Log

  @doc """
  Renders a list of logs.
  """
  def index(%{logs: logs}) do
    %{data: for(log <- logs, do: data(log))}
  end

  @doc """
  Renders a single log.
  """
  def show(%{log: log}) do
    %{data: data(log)}
  end

  defp data(%Log{} = log) do
    %{
      id: log.id,
      action: log.action,
      message: log.message,
      level: log.level
    }
  end
end
