defmodule OauthenatorApp.AccessTokenControllerTest do
  use OauthenatorApp.ConnCase
  alias OauthenatorApp.User
  alias Oauthenator.OauthClient

  setup do
    Ecto.Adapters.SQL.Sandbox.checkout(Oauthenator.Repo)
  end

  # TODO: pending test...
  # test "POST /oauth/access_token", %{conn: conn} do
  #   conn = post(conn, "/oauth/access_token", %{"code" => "asdf"})
  #
  # end

end
