defmodule TimeManagerApp.Logs do
  @moduledoc """
  The Logs context.
  """

  import Ecto.Query, warn: false
  alias TimeManagerApp.Repo
  alias TimeManagerApp.Logs.Log

  @doc """
  Returns the list of logs.
  """
  def list_logs do
    Repo.all(Log)
  end

  @doc """
  Gets a single log.
  """
  def get_log!(id), do: Repo.get!(Log, id)

  @doc """
  Creates a log.
  """
  def create_log(attrs \\ %{}) do
    %Log{}
    |> Log.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Logs an action with an optional user.
  """
  def log_action(user_id, action, message, level \\ "info") do
    %Log{}
    |> Log.changeset(%{user_id: user_id, action: action, message: message, level: level})
    |> Repo.insert()
  end

  @doc """
  Deletes a log.
  """
  def delete_log(%Log{} = log) do
    Repo.delete(log)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking log changes.
  """
  def change_log(%Log{} = log, attrs \\ %{}) do
    Log.changeset(log, attrs)
  end
end
