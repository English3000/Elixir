defmodule IslandsInterfaceWeb.ErrorViewTest do
  use IslandsInterfaceWeb.ConnCase, async: true

  import Phoenix.View # Bring render/3 and render_to_string/3 for testing custom views

  alias IslandsInterfaceWeb.ErrorView

  test "renders 404.html" do
    assert "Not Found" == render_to_string(ErrorView, "404.html", [])
  end

  test "renders 500.html" do
    assert "Internal Server Error" == render_to_string(ErrorView, "500.html", [])
  end
end
