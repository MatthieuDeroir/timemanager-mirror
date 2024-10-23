defmodule TimeManagerAppWeb.Swagger.RoleSwagger do
  use PhoenixSwagger

  def swagger_definitions do
    %{
      Role:
        swagger_schema do
          title("Role")
          description("A role within the system")

          properties do
            id(:integer, "Role ID", required: true)
            name(:string, "Role name", required: true)
            description(:string, "Role description", required: true)
          end
        end,
      CreateRole:
        swagger_schema do
          title("CreateRole")
          description("Schema for creating a role")

          properties do
            role(Schema.ref(:Role), "Role information", required: true)
          end
        end
    }
  end

  def paths do
    quote do
      swagger_path :index do
        description("Retrieve a list of roles.")
        response(200, "OK", Schema.ref(:Role))
      end

      swagger_path :create do
        description("Create a new role.")

        parameter(:role, :body, Schema.ref(:CreateRole), "The role information to create",
          required: true
        )

        response(201, "Role created", Schema.ref(:Role))
      end

      swagger_path :show do
        description("Retrieve a role by ID.")
        parameter(:id, :path, :integer, "Role ID", required: true)
        response(200, "Role found", Schema.ref(:Role))
        response(404, "Role not found")
      end

      swagger_path :update do
        description("Update an existing role.")
        parameter(:id, :path, :integer, "Role ID", required: true)

        parameter(:role, :body, Schema.ref(:CreateRole), "The role information to update",
          required: true
        )

        response(200, "Role updated", Schema.ref(:Role))
      end

      swagger_path :delete do
        description("Delete a role.")
        parameter(:id, :path, :integer, "Role ID", required: true)
        response(204, "Role deleted")
      end
    end
  end
end
