defmodule TimeManagerAppWeb.Swagger.TeamSwagger do
  use PhoenixSwagger

  def swagger_definitions do
    %{
      Team:
        swagger_schema do
          title("Team")
          description("A team within the system")

          properties do
            id(:integer, "Team ID", required: true)
            name(:string, "Team name", required: true)
            description(:string, "Team description", required: true)
          end
        end,
      CreateTeam:
        swagger_schema do
          title("CreateTeam")
          description("Schema for creating a team")

          properties do
            team(Schema.ref(:Team), "Team information", required: true)
          end
        end
    }
  end

  def paths do
    quote do
      swagger_path :index do
        description("Retrieve a list of teams.")
        response(200, "OK", Schema.ref(:Team))
      end

      swagger_path :create do
        description("Create a new team.")

        parameter(:team, :body, Schema.ref(:CreateTeam), "The team information to create",
          required: true
        )

        response(201, "Team created", Schema.ref(:Team))
      end

      swagger_path :show do
        description("Retrieve a team by ID.")
        parameter(:id, :path, :integer, "Team ID", required: true)
        response(200, "Team found", Schema.ref(:Team))
        response(404, "Team not found")
      end

      swagger_path :update do
        description("Update an existing team.")
        parameter(:id, :path, :integer, "Team ID", required: true)

        parameter(:team, :body, Schema.ref(:CreateTeam), "The team information to update",
          required: true
        )

        response(200, "Team updated", Schema.ref(:Team))
      end

      swagger_path :delete do
        description("Delete a team.")
        parameter(:id, :path, :integer, "Team ID", required: true)
        response(204, "Team deleted")
      end
    end
  end
end
