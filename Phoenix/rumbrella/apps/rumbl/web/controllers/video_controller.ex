defmodule Rumbl.VideoController do
  use Rumbl.Web, :controller

  alias Rumbl.Video
  alias Rumbl.Category

  plug :categories when action in [:new, :edit, :create, :update]

  @doc """
  Assigns `current_user` into `conn`, for all actions to access.
  """
  def action(conn, _options) do
    apply(__MODULE__, action_name(conn),
          [conn, conn.params, conn.assigns.current_user]) # returns 3 values
  end

  defp categories(conn, _options) do
    query = Category
      |> Category.order
      |> Category.fields

    categories = Repo.all query
    assign(conn, :categories, categories)
  end

  # Fetches all of a user's videos (a user `has_many` videos).
  defp user_videos(user) do
    assoc(user, :videos)
  end


  def index(conn, _params, user) do
    videos = Repo.all(user_videos(user))
    render(conn, "index.html", videos: videos)
  end

  def new(conn, _params, user) do
    changeset = user
      |> build_assoc(:videos)
      |> Video.changeset()

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"video" => video_params}, user) do
    changeset = user
      |> build_assoc(:videos)
      |> Video.changeset(video_params)

    case Repo.insert(changeset) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video created successfully.")
        |> redirect(to: video_path(conn, :index))#:show, video))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, user) do
    video = Repo.get!(user_videos(user), id)
    render(conn, "show.html", video: video)
  end

  def edit(conn, %{"id" => id}, user) do
    video = Repo.get!(user_videos(user), id)
    changeset = Video.changeset(video)
    render(conn, "edit.html", video: video, changeset: changeset)
  end

  def update(conn, %{"id" => id, "video" => video_params}, user) do
    video = Repo.get!(user_videos(user), id)
    changeset = Video.changeset(video, video_params)

    case Repo.update(changeset) do
      {:ok, video} ->
        conn
        |> put_flash(:info, "Video updated successfully.")
        |> redirect(to: video_path(conn, :show, video))
      {:error, changeset} ->
        render(conn, "edit.html", video: video, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    video = Repo.get!(user_videos(user), id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(video)

    conn
    |> put_flash(:info, "Video deleted successfully.")
    |> redirect(to: video_path(conn, :index))
  end
end
