defmodule FabricExWeb.PageController do
  use FabricExWeb, :controller

  def home(conn, _params) do
    # The landing page uses its own hero layout — skip app.html.heex
    # so we render directly inside root.html.heex.
    render(conn, :home, layout: false)
  end
end
