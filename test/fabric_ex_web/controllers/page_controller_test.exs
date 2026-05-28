defmodule FabricExWeb.PageControllerTest do
  use FabricExWeb.ConnCase

  test "GET / renders the Fabric Stash hero", %{conn: conn} do
    conn = get(conn, ~p"/")
    body = html_response(conn, 200)
    assert body =~ "Fabric Stash"
    assert body =~ "Shop your stash before you sew."
  end
end
