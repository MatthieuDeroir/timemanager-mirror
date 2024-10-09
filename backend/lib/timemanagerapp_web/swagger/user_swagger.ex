defmodule TimeManagerAppWeb.Swagger.UserSwagger do
  use PhoenixSwagger

  # Swagger schema definitions for the User entity
  def swagger_definitions do
    %{
      User:
        swagger_schema do
          title("User")
          description("A user of the application")

          properties do
            id(:integer, "User ID", required: true)
            email(:string, "User email address", required: true)
            username(:string, "Username of the user", required: true)
            name(:string, "User name", required: true)
          end
        end,
      CreateUser:
        swagger_schema do
          title("CreateUser")
          description("Schema for creating a user")

          properties do
            user(Schema.ref(:User), "User information", required: true)
          end
        end,
      UpdateUser:
        swagger_schema do
          title("UpdateUser")
          description("Schema for updating a user")

          properties do
            user(Schema.ref(:User), "User information", required: true)
          end
        end
    }
  end

  # Documentation for all actions (index, create, show, update, delete)
  def paths do
    quote do
      swagger_path :index do
        description("Retrieve one user based on the email and the username.")
        parameter(:email, :query, :string, "Email of the user")
        parameter(:username, :query, :string, "Username of the user")
        response(200, "OK", Schema.ref(:User))
      end

      swagger_path :create do
        description("Create a new user.")

        parameter(:user, :body, Schema.ref(:CreateUser), "The user information to create",
          required: true
        )

        response(201, "User created", Schema.ref(:User))
      end

      swagger_path :show do
        description("Retrieve a user by ID.")
        parameter(:id, :path, :integer, "User ID", required: true)
        response(200, "User found", Schema.ref(:User))
        response(404, "User not found")
      end

      swagger_path :update do
        description("Update an existing user.")
        parameter(:id, :path, :integer, "User ID", required: true)

        parameter(:user, :body, Schema.ref(:UpdateUser), "The user information to update",
          required: true
        )

        response(200, "User updated", Schema.ref(:User))
      end

      swagger_path :delete do
        description("Delete a user.")
        parameter(:id, :path, :integer, "User ID", required: true)
        response(204, "User deleted")
      end
    end
  end
end
