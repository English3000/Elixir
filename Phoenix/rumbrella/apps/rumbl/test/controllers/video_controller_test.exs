defmodule Rumbl.VideoControllerTest do
  use Rumbl.ConnCase
  alias Rumbl.Video

  @valid_attrs %{url: "http://youtu.be", title: "Video", description: "test video"}
  @invalid_attrs %{title: "invalid video"}

  setup %{conn: conn} = config do
    if username = config[:login_as] do
      user = insert_user(username: username)
      conn = assign(build_conn(), :current_user, user)
      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end

  test "requires user auth on all actions", %{conn: conn} do
    Enum.each([get(conn, video_path(conn, :new)),
               get(conn, video_path(conn, :index)),
               get(conn, video_path(conn, :show, "123")),
               get(conn, video_path(conn, :edit, "123")),
               put(conn, video_path(conn, :update, "123", %{})),
               post(conn, video_path(conn, :create, %{})),
               delete(conn, video_path(conn, :delete, "123"))],
      fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end)
  end

  @tag login_as: "test"
  test "lists user's videos on index", %{conn: conn, user: user} do
    user_video = insert_video(user, title: "test video")
    non_user_video = insert_video(insert_user(username: "other"), title: "other video")

    conn = get conn, video_path(conn, :index)
    assert html_response(conn, 200) =~ ~r/Listing videos/
    assert String.contains?(conn.resp_body, user_video.title)
    refute String.contains?(conn.resp_body, non_user_video.title)
  end

  defp video_count(query), do: Repo.one(from v in query, select: count(v.id))

  @tag login_as: "test"
  test "creates user video & redirects", %{conn: conn, user: user} do
    conn = post conn, video_path(conn, :create), video: @valid_attrs
    assert redirected_to(conn) == video_path(conn, :index)
    assert Repo.get_by!(Video, @valid_attrs).user_id == user.id
  end

  @tag login_as: "test"
  test "if invalid params: doesn't create video, renders errors", %{conn: conn} do
    count_before = video_count(Video)
    conn = post conn, video_path(conn, :create), video: @invalid_attrs
    assert html_response(conn, 200) =~ "check the errors"
    assert video_count(Video) == count_before
  end

  @tag login_as: "test"
  test "prevents actions by other users", %{user: owner, conn: conn} do
    video = insert_video(owner, @valid_attrs)
    non_owner = insert_user(username: "other")
    conn = assign(conn, :current_user, non_owner)

    assert_error_sent :not_found, fn ->
      get(conn, video_path(conn, :show, video))
    end
    assert_error_sent :not_found, fn ->
      get(conn, video_path(conn, :edit, video))
    end
    assert_error_sent :not_found, fn ->
      get(conn, video_path(conn, :update, video, video: @valid_attrs))
    end
    assert_error_sent :not_found, fn ->
      get(conn, video_path(conn, :delete, video))
    end
  end
end
