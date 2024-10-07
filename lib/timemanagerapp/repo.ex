defmodule TimeManagerApp.Repo do
  use Ecto.Repo,
    otp_app: :timemanagerapp,
    adapter: Ecto.Adapters.Postgres
end
