defmodule OauthenatorApp.AuthorizationControllerTest do
  use OauthenatorApp.ConnCase
  use Timex
  alias OauthenatorApp.{Repo, User}
  alias Oauthenator.{OauthClient, OauthAuthCode}

  @user %User{name: "Test", email: "test@example.com", password: "12345"}
  @oauth_user %Oauthenator.User{email: "test@example.com", password: "12345"}
  @client %OauthClient{name: "Test Client", random_id: "ABCD1234", secret: "qwerasdf", allowed_grant_types: "{\"authorization_code\":true}"}
  @params %{client_id: "ABCD1234", redirect_uri: "http://www.example.com", response_type: "authorization_code", state: "", scope: ""}

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(Oauthenator.Repo)
  end

  describe "when not logged in" do
    test "should redirect to login page", %{conn: conn} do
      conn = get(conn, "/oauth/authorize", @params)
      assert redirected_to(conn) == session_path(conn, :new)
    end
  end

  describe "when client app not found" do
    setup do
      conn = assign(build_conn, :current_user, Repo.insert!(@user))
      {:ok, conn: conn}
    end

    test "should return 404 - client not found", %{conn: conn} do
      conn = get(conn, "/oauth/authorize", @params)
      assert response(conn, 404) =~ "Client not found"
    end
  end

  describe "when logged in and client app exists" do
    setup do
      user = Oauthenator.Repo.insert!(@oauth_user)
      client = Oauthenator.Repo.insert!(@client)
      conn = assign(build_conn, :current_user, %{@user | id: user.id})
      {:ok, conn: conn, user: user, client: client}
    end

    test "get displays the client app details", %{conn: conn} do
      conn = get(conn, "/oauth/authorize", @params)
      assert html_response(conn, 200) =~ "Authorize Application"
    end

    test "post redirects to the client app and provides the authorization code", %{conn: conn} do
      conn = post(conn, "/oauth/authorize", @params)
      assert redirected_to(conn) == "http://www.example.com?code=AUTH-CODE-EXAMPLE"
    end

    test "post deletes an existing auth code", %{conn: conn, user: user, client: client} do
      existing_code = OauthAuthCode.changeset(%OauthAuthCode{}, %{
        "code" => "asdf",
        "expires_at" => Timex.shift(DateTime.now, days: 30),
        "user_id" => user.id,
        "oauth_client_id" => client.id
      }) |> Oauthenator.Repo.insert!
      conn = post(conn, "/oauth/authorize", @params)
      assert redirected_to(conn) == "http://www.example.com?code=AUTH-CODE-EXAMPLE"
      assert Oauthenator.Repo.get(OauthAuthCode, existing_code.id) == nil
    end
  end

end
