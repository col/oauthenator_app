defmodule OauthenatorApp.AuthorizationTest do
  use OauthenatorApp.ModelCase
  alias OauthenatorApp.Authorization

  @valid_attrs %{client_id: "asdf", redirect_url: "qwer", response_type: "authorization_code"}
  @invalid_attrs %{}

  # test "changeset with valid attributes" do
  #   changeset = Authorization.changeset(%Authorization{}, @valid_attrs)
  #   assert changeset.valid?
  # end
  #
  # test "changeset with invalid attributes" do
  #   changeset = Authorization.changeset(%Authorization{}, @invalid_attrs)
  #   refute changeset.valid?
  # end

  test "should be valid with valid attributes" do
    authorization = Map.merge(%Authorization{}, @valid_attrs)
    assert :ok = Authorization.valid?(authorization)
  end

  test "should be invalid with invalid attributes" do
    authorization = Map.merge(%Authorization{}, @invalid_attrs)
    assert {:error, errors} = Authorization.valid?(authorization)
  end

end
