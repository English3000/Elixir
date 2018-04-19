defmodule Rumbl.AnnotationView do
  use Rumbl.Web, :view

  def render("annotation.json", %{annotation: a}) do
    %{ id: a.id, body: a.body, at: a.at,
       user: render_one(a.user, Rumbl.UserView, "user.json") }
  end
end
