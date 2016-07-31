defmodule OauthenatorApp.AccessTokenController do
  use OauthenatorApp.Web, :controller
  use Timex
  # alias OauthenatorApp.Authorization
  alias Oauthenator.{Oauth, OauthAuthCode, OauthAccessToken}

  def create(conn, params) do
    IO.puts "AccessTokenController Params = #{inspect params}"
    # %{
    #   "client_id" => "qZ8XtgqElxAaKVo-e_D3kAyfl8oVZnShzxecWaHJ",
    #   "client_secret" => "JF1UZmT2I6SZ17VDNrwABJEX-RijTF4_n70jbJge",
    #   "code" => "1234ABCD",
    #   "grant_type" => "authorization_code",
    #   "redirect_uri" => "http://lvh.me:4000/auth/oauthenator/callback"
    # }
    case OauthAuthCode.get_auth_code(params["code"], DateTime.now) do
      nil ->
        render conn, :show, %{error: "invalid auth code"}
      auth_code ->
        case Oauth.generate_access_token(auth_code.oauth_client_id, auth_code.user_id) do
          {:ok, access_token} ->
            render conn, :show, %{token: access_token.token}
          {:error, _} ->
            render conn, :show, %{error: "failed to generate access token"}
        end
    end
  end

end
