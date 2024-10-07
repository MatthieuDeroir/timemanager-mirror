defmodule Todolist.Repo do
  use Ecto.Repo,
    otp_app: :timeManagerApp,
    adapter: Ecto.Adapters.Postgres
end
