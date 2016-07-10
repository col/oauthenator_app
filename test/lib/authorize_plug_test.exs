defmodule Oauth.AuthorizePlugTest do
  use ExUnit.Case
  use Plug.Test
  use Oauthenator

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  @options AuthorizePlug.init([])
  @client %OauthClient{
    name: "Test",
    random_id: "ABCD1234",
    secret: "qwerasdf",
    allowed_grant_types: "{\"authorization_code\":true}"
  }
  @auth_params %{
    "response_type": "authorization_code",
    "client_id": @client.random_id,
    "redirect_uri": "https://www.someservice.com/oauth/callback",
    "scope": "scope"
  }

  setup do
    conn = conn(:get, "/", @auth_params)
    {:ok, conn: conn}
  end

  test "should return 400 if the request params are invalid", %{conn: conn} do
    conn = %{conn | params: %{}}
    conn = AuthorizePlug.call(conn, @options)

    assert conn.state == :sent
    assert conn.status == 400
    assert conn.resp_body == "Invalid request"
  end

  test "should return 404 if the client id is not found", %{conn: conn} do
    conn = AuthorizePlug.call(conn, @options)

    assert conn.state == :sent
    assert conn.status == 404
    assert conn.resp_body == "Client not found"
  end

  test "should return 200 when the client is found", %{conn: conn} do
    @client |> Repo.insert!

    conn = AuthorizePlug.call(conn, @options)
    assert conn.state == :unset
  end

  test "should assign the client", %{conn: conn} do
    client = @client |> Repo.insert!

    conn = AuthorizePlug.call(conn, @options)
    assert conn.assigns.oauth_client == client
  end

end
