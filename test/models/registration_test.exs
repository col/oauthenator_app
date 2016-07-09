defmodule OauthenatorApp.RegistrationTest do
  use OauthenatorApp.ModelCase

  alias OauthenatorApp.Registration

  @valid_attrs %{email: "some content", name: "some content", new_password: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Registration.changeset(%Registration{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Registration.changeset(%Registration{}, @invalid_attrs)
    refute changeset.valid?
  end
end
