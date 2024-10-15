defmodule TimeManagerAppWeb.Router do
  use TimeManagerAppWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", TimeManagerAppWeb do
    pipe_through(:api)
    # User Routes
    resources("/users", UserController, except: [:new, :edit])
    get("/users/teams/:team_id", UserController, :index_team)
    # Clock Routes
    get("/clocks/:user_id", ClockController, :index)
    post("/clocks/:user_id", ClockController, :create)
    get("/clocks/:user_id/:id", ClockController, :show)

    # WorkingTime Routes
    get("/workingtime/:user_id", WorkingTimeController, :index)
    get("/workingtime/:user_id/:id", WorkingTimeController, :show)
    post("/workingtime/:user_id", WorkingTimeController, :create)
    put("/workingtime/:id", WorkingTimeController, :update)
    delete("/workingtime/:id", WorkingTimeController, :delete)

    # Role Routes
    resources("/roles", RoleController, except: [:new, :edit])

    # Team Routes
    resources("/teams", TeamController, except: [:new, :edit])
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
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through([:fetch_session, :protect_from_forgery])

      live_dashboard("/dashboard", metrics: TimeManagerAppWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
