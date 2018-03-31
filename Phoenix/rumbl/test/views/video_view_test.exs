defmodule Rumbl.VideoViewTest do
  use Rumbl.ConnCase, async: true
  import Phoenix.View
  alias Rumbl.Video

  test "index.html rendered", %{conn: conn} do
    videos = [%Video{id: "1", title: "Video 1"},
              %Video{id: "2", title: "Video 2"}]

    content = render_to_string(Rumbl.VideoView, "index.html",
                               conn: conn, videos: videos)

    assert String.contains?(content, "Listing videos")
    for video <- videos do
      assert String.contains?(content, video.title)
    end
  end

  test "new.html rendered", %{conn: conn} do
    changeset = Video.changeset(%Video{})
    categories = [{"testing", 123}]

    content = render_to_string(Rumbl.VideoView, "new.html", conn: conn,
                               changeset: changeset, categories: categories)

    assert String.contains?(content, "New video")
  end
end
