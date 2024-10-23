# test/support/conn_case.ex
defmodule TimeManagerAppWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias TimeManagerAppWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint TimeManagerAppWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TimeManagerApp.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(TimeManagerApp.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
