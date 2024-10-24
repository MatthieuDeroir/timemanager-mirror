defmodule TimeManagerAppWeb.Router do
  use TimeManagerAppWeb, :router
  alias TimeManagerAppWeb.Plugs.AuthorizeRole

  @moduledoc """
  The Router module for the TimeManagerAppWeb.

  This module defines the routes for the API, segregating them into public and authenticated routes,
  and further by user roles such as employee, manager, general manager, and admin.

  ## Pipelines

    * `:api` - Ensures that requests are accepted in JSON format.
    * `:authenticated` - Verifies that the user is authenticated.
    * `:role_employee` - Ensures that the user has an employee role.
    * `:role_manager` - Ensures that the user has a manager role.
    * `:role_general_manager` - Ensures that the user has a general manager role.
    * `:role_admin` - Ensures that the user has an admin role.

  ## Public Routes

    * `POST /api/auth/login` - Logs in a user.
    * `POST /api/auth/logout` - Logs out a user.
    * `POST /api/auth/register` - Registers a new user.
    * `GET /api/users` - Lists users.
    * `GET /api/users/:id` - Shows a user.
    * `POST /api/users` - Creates a new user.

  ## Authenticated Routes

  ### Role: Employee
    * `GET /api/clocks/:user_id` - Lists clock entries for a user.
    * `POST /api/clocks/:user_id` - Creates a clock entry for a user.
    * `GET /api/clocks/:user_id/:id` - Shows a specific clock entry.
    * `GET /api/workingtime/:user_id` - Lists working times for a user.
    * `GET /api/workingtime/:user_id/:id` - Shows a specific working time entry.
    * `GET /api/teams/users/:team_id` - Lists users in a team.
    * `GET /api/users/teams/:user_id` - Lists teams of a user.
    * `GET /api/roles` - Lists roles.
    * `POST /api/roles` - Creates a new role.
    * `DELETE /api/roles/:id` - Deletes a role.

  ### Role: Manager
    * `POST /api/workingtime/:user_id` - Creates a working time entry for a user.
    * `PUT /api/workingtime/:id` - Updates a working time entry.
    * `DELETE /api/workingtime/:id` - Deletes a working time entry.
    * `POST /api/user_teams/add` - Adds a user to a team.
    * `DELETE /api/user_teams/remove` - Removes a user from a team.

  ### Role: General Manager
    * `PUT /api/teams/:id` - Updates a team.
    * `DELETE /api/teams/:id` - Deletes a team.
    * `GET /api/teams/:id/edit` - Gets the edit form for a team.
    * `GET /api/teams/new` - Gets the form to create a new team.

  ### Role: Admin
    * `GET /api/users` - Lists users.
    * `POST /api/users` - Creates a new user.
    * `GET /api/users/:id` - Shows a user.
    * `PUT /api/users/:id` - Updates a user.
    * `DELETE /api/users/:id` - Deletes a user.
    * `GET /api/logs` - Lists logs.
    * `GET /api/logs/:id` - Shows a specific log.

  ## Development Routes

    These routes are only available in the development environment.

    * `GET /dev/dashboard` - Shows the live dashboard for telemetry metrics.
    * `GET /dev/mailbox` - Shows the mailbox preview.

  ## Swagger UI Route

    * `GET /api/swagger` - Forwards to the SwaggerUI for API documentation.
  """

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :authenticated do
    plug(TimeManagerAppWeb.Plugs.AuthPlug)
  end

  pipeline :role_employee do
    plug AuthorizeRole, 4
  end

  pipeline :role_manager do
    plug AuthorizeRole, 3
  end

  pipeline :role_general_manager do
    plug AuthorizeRole, 2
  end

  pipeline :role_admin do
    plug AuthorizeRole, 1
  end

  # Public Routes
  scope "/api", TimeManagerAppWeb do
    pipe_through(:api)

    post("/auth/login", SessionController, :login)
    post("/auth/logout", SessionController, :logout)
    post("/auth/register", SessionController, :register)
    resources("/users", UserController, only: [:index, :show, :create])

    scope "/" do
      pipe_through(:authenticated)

      scope "/" do
        pipe_through(:role_employee)
        get("/clocks/:user_id", ClockController, :index)
        post("/clocks/:user_id", ClockController, :create)
        get("/clocks/:user_id/:id", ClockController, :show)
        get("/workingtime/:user_id", WorkingTimeController, :index)
        get("/workingtime/:user_id/:id", WorkingTimeController, :show)
        get("/teams/users/:team_id", UserTeamController, :list_users_in_team)
        get("/users/teams/:user_id", UserTeamController, :list_teams_of_user)
        resources("/roles", RoleController, except: [:new, :edit])
      end

      scope "/" do
        pipe_through(:role_manager)
        post("/workingtime/:user_id", WorkingTimeController, :create)
        put("/workingtime/:id", WorkingTimeController, :update)
        delete("/workingtime/:id", WorkingTimeController, :delete)
        post("/user_teams/add", UserTeamController, :add_user_to_team)
        post("/user_teams/remove", UserTeamController, :remove_user_from_team)
      end

      scope "/" do
        pipe_through(:role_general_manager)
        resources("/teams", TeamController, except: [:update, :delete, :edit, :new])
      end

      scope "/" do
        pipe_through(:role_admin)
        resources("/users", UserController, except: [:new, :edit])
        resources("/logs", LogController, only: [:index, :show])
      end
    end
  end

  # Swagger UI Route
  scope "/api/swagger" do
    forward("/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :timemanagerapp,
      swagger_file: "swagger.json"
    )
  end

  # Development Routes (only active in dev mode)
  if Application.compile_env(:timemanagerapp, :dev_routes) do
    import Phoenix.LiveDashboard.Router
    scope "/dev" do
      pipe_through([:fetch_session, :protect_from_forgery])
      live_dashboard("/dashboard", metrics: TimeManagerAppWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end

  @doc """
  Returns the OpenAPI specification info.
  """
  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "TimeManagerApp API - T-POO-700-NAN_5"
      }
    }
  end
end