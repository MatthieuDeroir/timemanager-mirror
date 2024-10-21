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

  scope "/api", TimeManagerAppWeb do
    pipe_through(:api)

    post("auth/login", SessionController, :login)
    post("auth/logout", SessionController, :logout)
    post("auth/register", SessionController, :register)

    resources "/users", UserController, except: [:new, :edit, :update, :delete] do
      get("/teams", UserController, :user_teams)
    end
  end

  scope "/api", TimeManagerAppWeb do
    pipe_through([:api, :authenticated, :employee])

    # Clock Routes
    get("/clocks/:user_id", ClockController, :index)

    post("/clocks/:user_id", ClockController, :create)
    get("/clocks/:user_id/:id", ClockController, :show)

    # WorkingTime Routes
    get("/workingtime/:user_id", WorkingTimeController, :index)
    get("/workingtime/:user_id/:id", WorkingTimeController, :show)

    # Role Routes
    resources("/roles", RoleController, except: [:new, :edit])

    # Team Routes
    resources "/teams", TeamController, except: [:new, :edit] do
      get("/users", TeamController, :team_users)
    end
  end

  # Other scopes with higher role requirements
  scope "/api", TimeManagerAppWeb do
    pipe_through([:api, :authenticated, :manager])

    post("/workingtime/:user_id", WorkingTimeController, :create)
    put("/workingtime/:id", WorkingTimeController, :update)
    delete("/workingtime/:id", WorkingTimeController, :delete)
  end

  scope "/api", TimeManagerAppWeb do
    pipe_through([:api, :authenticated, :general_manager])

    post("teams/users/add", TeamController, :add_user)
    delete("teams/users/remove", TeamController, :remove_user)
  end

  scope "/api", TimeManagerAppWeb do
    pipe_through([:api, :authenticated, :admin])

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

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:timemanagerapp, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through([:fetch_session, :protect_from_forgery])

      live_dashboard("/dashboard", metrics: TimeManagerAppWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
