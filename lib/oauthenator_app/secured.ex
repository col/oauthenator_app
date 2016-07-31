# TODO: this needs a lot of work.
defmodule OauthenatorApp.Secured do
  import Plug.Conn
  use Timex

  def init(default), do: default

  def call(%Plug.Conn{params: %{"access_token" => access_token}} = conn, _default) do
    access_token = Oauthenator.OauthAccessToken.get_access_token(access_token, DateTime.now);

    case access_token do
      nil ->
        conn
          # |> put_resp_content_type("application/json")
          # |> send_resp(400, Poison.encode!(%{message: "Not authorized"}))
      _ ->
        case access_token.user_id do
          nil ->
            conn
              # |> put_resp_content_type("application/json")
              # |> send_resp(400, Poison.encode!(%{message: "Not authorized"}))
          _ ->
            # user = Oauthenator.Repo.get(Oauthenator.User, access_token.user_id)
            put_session(conn, :user_id, access_token.user_id)
        end
    end
  end

  def call(conn, default) do
      conn
        # |> put_resp_content_type("application/json")
        # |> send_resp(400, Poison.encode!(%{message: "Not authorized"}))
  end
end
