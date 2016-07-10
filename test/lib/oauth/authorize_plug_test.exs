defmodule Oauth.AuthorizePlugTest do
  use ExUnit.Case
  use Plug.Test
  use Oauthenator

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  @options AuthorizePlug.init([])
  @client_id "ABCD1234"

  setup do
    conn = conn(:get, "/", %{
      "response_type": "code",
      "client_id": @client_id,
      "redirect_uri": "https://www.someservice.com/oauth/callback",
      "scope": "scope"
    })
    {:ok, conn: conn}
  end

  test "should return 404 if the client id is not found", %{conn: conn} do
    conn = AuthorizePlug.call(conn, @options)

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == "Client not found"
  end

  test "should return 200 when the client is found", %{conn: conn} do
    %OauthClient{name: "Test", random_id: @client_id, secret: "qwerasdf", allowed_grant_types: "{\"authorization_code\":true}"} |> Repo.insert!

    conn = AuthorizePlug.call(conn, @options)
    assert conn.state == :unset
  end

  test "should assign the client", %{conn: conn} do
    client = %OauthClient{name: "Test", random_id: @client_id, secret: "qwerasdf", allowed_grant_types: "{\"authorization_code\":true}"} |> Repo.insert!

    conn = AuthorizePlug.call(conn, @options)
    assert conn.assigns.oauth_client == client
  end

end
