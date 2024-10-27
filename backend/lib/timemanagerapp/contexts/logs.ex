# lib/timemanagerapp/logs.ex
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

  def list_logs_by_role(role_id) do
    Log
    |> join(:inner, [l], u in assoc(l, :user))
    |> where([l, u], u.role_id == ^role_id)
    |> Repo.all()
    |> Repo.preload([user: [:role, :teams]])
  end

  def list_logs_by_team(team_id) do
    Log
    |> join(:inner, [l], u in assoc(l, :user))
    |> join(:inner, [l, u], t in assoc(u, :teams))
    |> where([l, u, t], t.id == ^team_id)
    |> Repo.all()
    |> Repo.preload([user: [:role, :teams]])
  end

  def list_logs_by_user(user_id, page \\ 1, page_size \\ 50) do
    offset = (page - 1) * page_size

    Log
    |> where([l], l.user_id == ^user_id)
    |> limit(^page_size)
    |> offset(^offset)
    |> Repo.all()
    |> Repo.preload([user: [:role, :teams]])
  end

  def list_logs_by_date_range(start_date, end_date) do
    Log
    |> where([l], l.inserted_at >= ^start_date and l.inserted_at <= ^end_date)
    |> Repo.all()
    |> Repo.preload([user: [:role, :teams]])
  end

  def list_logs_by_role_and_date(role_id, start_date, end_date) do
    Log
    |> join(:inner, [l], u in assoc(l, :user))
    |> where([l, u], u.role_id == ^role_id)
    |> where([l], l.inserted_at >= ^start_date and l.inserted_at <= ^end_date)
    |> Repo.all()
    |> Repo.preload([user: [:role, :teams]])
  end

  def list_logs_by_team_and_date(team_id, start_date, end_date) do
    Log
    |> join(:inner, [l], u in assoc(l, :user))
    |> join(:inner, [l, u], t in assoc(u, :teams))
    |> where([l, u, t], t.id == ^team_id)
    |> where([l], l.inserted_at >= ^start_date and l.inserted_at <= ^end_date)
    |> Repo.all()
    |> Repo.preload([user: [:role, :teams]])
  end

  def list_logs_by_user_and_date(user_id, start_date, end_date) do
    Log
    |> where([l], l.user_id == ^user_id)
    |> where([l], l.inserted_at >= ^start_date and l.inserted_at <= ^end_date)
    |> Repo.all()
    |> Repo.preload([user: [:role, :teams]])
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
  Updates a log.
  """
  def update_log(%Log{} = log, attrs) do
    log
    |> Log.changeset(attrs)
    |> Repo.update()
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
