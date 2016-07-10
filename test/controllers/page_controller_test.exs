defmodule OauthenatorApp.PageControllerTest do
  use OauthenatorApp.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Oauthenator Example App"
  end
end
