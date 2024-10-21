defmodule TimeManagerAppWeb.Router do
  use TimeManagerAppWeb, :router

  alias TimeManagerAppWeb.Plugs.AuthorizeRole

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :authenticated do
    plug(TimeManagerAppWeb.Plugs.AuthPlug)
  end

  pipeline :employee do
    plug(AuthorizeRole, 4)
  end

  pipeline :manager do
    plug(AuthorizeRole, 3)
  end

  pipeline :general_manager do
    plug(AuthorizeRole, 2)
  end

  pipeline :admin do
    plug(AuthorizeRole, 1)
  end

  # TODO: reenable Role-Based Access Control when development is done
  # public routes
  scope "/api", TimeManagerAppWeb do
    pipe_through(:api)

    post("auth/login", SessionController, :login)
    post("auth/logout", SessionController, :logout)
    post("auth/register", SessionController, :register)

    resources "/users", UserController, except: [:new, :edit, :update, :delete] do
      get("/teams/:user_id", UserController, :user_teams)
    end
  end

  # employee routes
  scope "/api", TimeManagerAppWeb do
    pipe_through([:api, :authenticated])

    get("/clocks/:user_id", ClockController, :index)

    post("/clocks/:user_id", ClockController, :create)
    get("/clocks/:user_id/:id", ClockController, :show)

    get("/workingtime/:user_id", WorkingTimeController, :index)
    get("/workingtime/:user_id/:id", WorkingTimeController, :show)

    resources("/roles", RoleController, except: [:new, :edit])

    resources "/teams", TeamController, except: [:new, :edit, :update, :delete] do
      get("/users/:team_id", TeamController, :team_users)
    end
  end

  # manager routes
  scope "/api", TimeManagerAppWeb do
    pipe_through([:api, :authenticated])

    post("/workingtime/:user_id", WorkingTimeController, :create)
    put("/workingtime/:id", WorkingTimeController, :update)
    delete("/workingtime/:id", WorkingTimeController, :delete)
  end

  # general manager routes
  scope "/api", TimeManagerAppWeb do
    pipe_through([:api, :authenticated])

    post("teams/:team_id/users/:user_id", TeamController, :add_user)
    delete("teams/:team_id/users/:user_id", TeamController, :remove_user)
  end

  # admin routes
  scope "/api", TimeManagerAppWeb do
    pipe_through([:api, :authenticated])

    resources("/users", UserController, except: [:new, :edit])
    resources("/logs", LogController, only: [:index, :show])
  end

  scope "/api/swagger" do
    forward("/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :timemanagerapp,
      swagger_file: "swagger.json"
    )
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "TimeManagerApp API - T-POO-700-NAN_5"
      }
    }
  end

  if Application.compile_env(:timemanagerapp, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through([:fetch_session, :protect_from_forgery])

      live_dashboard("/dashboard", metrics: TimeManagerAppWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
