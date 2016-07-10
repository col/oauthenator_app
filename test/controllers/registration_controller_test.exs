defmodule OauthenatorApp.RegistrationControllerTest do
  use OauthenatorApp.ConnCase
  alias OauthenatorApp.User

  @valid_attrs %{email: "some content", name: "some content", new_password: "some content"}
  @invalid_attrs %{}

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, registration_path(conn, :new)
    assert html_response(conn, 200) =~ "New registration"
  end

  test "creates and displays registration when data is valid", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: @valid_attrs
    assert html_response(conn, 200) =~ "You have registered successfully"
    assert Repo.get_by(User, %{email: "some content", name: "some content"})
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: @invalid_attrs
    assert html_response(conn, 200) =~ "New registration"
  end

end
