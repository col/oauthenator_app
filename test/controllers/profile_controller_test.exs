defmodule OauthenatorApp.ProfileControllerTest do
  use OauthenatorApp.ConnCase
  alias OauthenatorApp.{Repo, User}
  alias Oauthenator.{OauthClient, OauthAccessToken}

  setup tags do
    user = %User{name: "Test", email: "test@example.com", password: "password"} |> Repo.insert!
    {:ok, user: user}
  end

  test "GET /profile/:id", %{conn: conn, user: user} do
    conn = get conn, "/profile/#{user.id}"
    assert html_response(conn, 200) =~ "My Profile"
  end

  test "GET /api/profile/:id as json", %{conn: conn, user: user} do
    client = OauthClient.chaneset(%OauthClient{}, %{
      name: "Test Client",
      random_id: "ABCD1234",
      secret: "qwerasdf",
      allowed_grant_types: "{\"authorization_code\":true}"
    }) |> Oauthenator.Repo.insert!
    OauthAccessToken.changeset(%OauthAccessToken{}, %{
      "token" => "valid-token",
      "expires_at" => Timex.shift(DateTime.now, days: 30),
      "user_id" => user.id,
      "oauth_client_id" => client.id
      }) |> Oauthenator.Repo.insert!
    conn = get(conn, "/api/profile/#{user.id}", %{"access_token" => "valid-token"})
    IO.puts "User = #{inspect user}"
    user_as_json = Poison.encode!(user)
    # IO.puts "User as json = #{inspect user_as_json}"
    assert conn.resp_body == "{\"name\":\"Test\"}"
  end

  test "GET /profile/:id/edit", %{conn: conn, user: user} do
    conn = get conn, "/profile/#{user.id}/edit"
    assert html_response(conn, 200) =~ "Edit Profile"
  end

  test "PATCH /profile/:id", %{conn: conn, user: user} do
    conn = patch conn, "/profile/#{user.id}", user: %{"name" => "New Name"}
    assert redirected_to(conn) == profile_path(conn, :show, user)
    assert Repo.get!(User, user.id).name == "New Name"
  end

end
