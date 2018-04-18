defmodule Rumbl.VideoChannel do
  use Rumbl.Web, :channel
                     # v-- string destructuring
  def join("videos:" <> video_id, params, socket) do
    last_seen_id = params["last_seen_id"] || 0
    video_id = String.to_integer(video_id)
    video = Repo.get!(Rumbl.Video, video_id)

    annotations = Repo.all( from a in assoc(video, :annotations),
                            where: a.id > ^last_seen_id,
                            order_by: [asc: a.at, asc: a.id],
                            limit: 200,
                            preload: [:user] )

    response = %{annotations:
      Phoenix.View.render_many(annotations, Rumbl.AnnotationView, "annotation.json")}

    {:ok, response, assign(socket, :video_id, video_id)}
  end

  def handle_in("new_annotation", params, socket) do
    user = Repo.get(Rumbl.User, socket.assigns.user_id)

    changeset = user |> build_assoc(:annotations, video_id: socket.assigns.video_id)
                     |> Rumbl.Annotation.changeset(params)
    # persist annotation to db
    case Repo.insert(changeset) do
      # broadcast to subscribers on success
      {:ok, annotation}  -> broadcast! socket, "new_annotation",
        %{ id: annotation.id,
           user: Rumbl.UserView.render("user.json", %{user: user}),
           body: annotation.body,
           at: annotation.at }

        {:reply, :ok, socket}
      # else, return errors
      {:error, changeset} -> {:reply, {:error, %{errors: changeset}}, socket}
    end


    {:reply, :ok, socket}
  end

  # def handle_info(:ping, socket) do
  #   count = socket.assigns[:count] || 1
  #   push socket, "ping", %{count: count}
  #   {:noreply, assign(socket, :count, count + 1)}
  # end
end
