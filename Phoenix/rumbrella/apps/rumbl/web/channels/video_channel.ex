defmodule Rumbl.VideoChannel do
  use Rumbl.Web, :channel
  alias Rumbl.{Video, User, Annotation}
                     # v-- string destructuring
  def join("videos:" <> video_id, params, socket) do
    last_seen_id = params["last_seen_id"] || 0
    video_id = String.to_integer(video_id)
    video = Repo.get!(Video, video_id)

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
    user = Repo.get(User, socket.assigns.user_id)

    changeset = user |> build_assoc(:annotations, video_id: socket.assigns.video_id)
                     |> Rumbl.Annotation.changeset(params)
    # persist annotation to db
    case Repo.insert(changeset) do
      # broadcast to subscribers on success
      {:ok, annotation}  -> broadcast_annotation(socket, "new_annotation")
        # %{ id: annotation.id,
        #    user: Rumbl.UserView.render("user.json", %{user: user}),
        #    body: annotation.body,
        #    at: annotation.at }
                              # use `Task` so don't block the channel
                              Task.start_link(fn -> compute_addl_info(annotation, socket) end)
                              {:reply, :ok, socket}
      # else, return errors
      {:error, changeset} -> {:reply, {:error, %{errors: changeset}}, socket}
    end


    {:reply, :ok, socket}
  end

  defp broadcast_annotation(socket, annotation) do
    annotation = Repo.preload(annotation, :user)
    rendered = Phoenix.View.render(AnnotationView, "annotation.json", %{annotation: annotation})

    broadcast! socket, "new_annotation", rendered #why not `annotation` as arg 2?
  end

  defp compute_addl_info(annotation, socket) do
    for result <- InfoSys.compute(annotation.body, limit: 1, timeout: 10_000) do
      attrs = %{url: result.url, body: result.text, at: annotation.at}

      info_changeset = Repo.get_by!(User, username: result.backend)
                       |> build_assoc(:annotations, video_id: annotation.video_id)
                       |> Annotation.changeset(attrs)

      case Repo.insert(info_changeset) do
        {:ok, info}          -> broadcast_annotation(socket, info)
        {:error, _changeset} -> :ignore
      end
    end
  end

  # def handle_info(:ping, socket) do
  #   count = socket.assigns[:count] || 1
  #   push socket, "ping", %{count: count}
  #   {:noreply, assign(socket, :count, count + 1)}
  # end
end
