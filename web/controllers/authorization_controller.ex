defmodule OauthenatorApp.AuthorizationController do
  use OauthenatorApp.Web, :controller
  alias OauthenatorApp.Authorization
  alias Oauthenator.{Oauth, OauthAccessToken, OauthAuthCode}

  plug AuthorizePlug, only: [:index]

  def new(conn, params) do
    render conn, "index.html",
      oauth_client: Map.get(conn.assigns, :oauth_client),
      authorization: conn.assigns.authorization
  end

  def create(conn, params) do
    authorization = Ecto.Changeset.apply_changes(conn.assigns.authorization)
    # TODO: do more stuff here!
    client_id = conn.assigns.oauth_client.id
    user_id = conn.assigns.current_user.id
    IO.puts "Create token with client id = #{client_id} and user id = #{user_id}"
    # For "Authorization Code" flow, we need to generate an auth_code rather than an access_token
    # {:ok, token} = Oauthenator.Oauth.generate_access_token(client_id, user_id)
    case OauthAuthCode.get_existing_auth_code(user_id, client_id) do
      nil -> false
      existing_code -> Oauthenator.Repo.delete!(existing_code)
    end
    {:ok, auth_code} = Oauth.generate_auth_code(client_id, user_id)
    redirect(conn, external: "#{authorization.redirect_uri}?code=#{auth_code.code}")
  end
end
