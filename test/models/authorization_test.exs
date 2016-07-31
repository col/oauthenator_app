defmodule OauthenatorApp.AuthorizationTest do
  use OauthenatorApp.ModelCase
  alias OauthenatorApp.Authorization

  @valid_attrs %{client_id: "asdf", redirect_uri: "qwer", response_type: "authorization_code"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Authorization.changeset(%Authorization{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Authorization.changeset(%Authorization{}, @invalid_attrs)
    refute changeset.valid?
  end

end
