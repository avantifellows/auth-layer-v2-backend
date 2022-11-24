defmodule DbserviceWeb.TeacherController do
  use DbserviceWeb, :controller

  alias Dbservice.Users
  alias Dbservice.Users.Teacher

  action_fallback DbserviceWeb.FallbackController

  use PhoenixSwagger

  alias DbserviceWeb.SwaggerSchema.Teacher, as: SwaggerSchemaTeacher

  def swagger_definitions do
    Map.merge(
      SwaggerSchemaTeacher.teacher(),
      SwaggerSchemaTeacher.teachers()
    )
  end

  swagger_path :index do
    get("/api/teacher")
    response(200, "OK", Schema.ref(:Teachers))
  end

  def index(conn, _params) do
    teacher = Users.list_teacher()
    render(conn, "index.json", teacher: teacher)
  end

  swagger_path :create do
    post("/api/teacher")

    parameters do
      body(:body, Schema.ref(:Teacher), "Teacher to create", required: true)
    end

    response(201, "Created", Schema.ref(:Teacher))
  end

  def create(conn, params) do
    with {:ok, %Teacher{} = teacher} <- Users.create_teacher(params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.teacher_path(conn, :show, teacher))
      |> render("show.json", teacher: teacher)
    end
  end

  swagger_path :show do
    get("/api/teacher/{teacherId}")

    parameters do
      teacherId(:path, :integer, "The id of the teacher", required: true)
    end

    response(200, "OK", Schema.ref(:Teacher))
  end

  def show(conn, %{"id" => id}) do
    teacher = Users.get_teacher!(id)
    render(conn, "show.json", teacher: teacher)
  end

  def update(conn, params) do
    teacher = Users.get_teacher!(params["id"])

    with {:ok, %Teacher{} = teacher} <- Users.update_teacher(teacher, params) do
      render(conn, "show.json", teacher: teacher)
    end
  end

  swagger_path :update do
    patch("/api/teacher/{teacherId}")

    parameters do
      teacherId(:path, :integer, "The id of the teacher", required: true)
      body(:body, Schema.ref(:Teacher), "Teacher to create", required: true)
    end

    response(200, "Updated", Schema.ref(:Teacher))
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/teacher/{teacherId}")

    parameters do
      teacherId(:path, :integer, "The id of the teacher", required: true)
    end

    response(204, "No Content")
  end

  def delete(conn, %{"id" => id}) do
    teacher = Users.get_teacher!(id)

    with {:ok, %Teacher{}} <- Users.delete_teacher(teacher) do
      send_resp(conn, :no_content, "")
    end
  end

  def register(conn, params) do
    with {:ok, %Teacher{} = teacher} <- Users.create_teacher_with_user(params) do
      conn
      |> put_status(:created)
      |> render("show_with_user.json", teacher: teacher)
    end
  end

  def update_teacher_with_user(conn, params) do
    teacher = Users.get_teacher!(params["id"])
    user = Users.get_user!(teacher.user_id)

    with {:ok, %Teacher{} = teacher} <- Users.update_teacher_with_user(teacher, user, params) do
      conn
      |> put_status(:ok)
      |> render("show_with_user.json", teacher: teacher)
    end
  end
end
