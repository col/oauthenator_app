defmodule OauthenatorApp.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string
    field :new_password, :string, virtual: true

    timestamps()
  end

  @required_fields ~w(name email password)
  @optional_fields ~w()

  def changeset(model, params \\ %{}) do
    model
      |> cast(params, @required_fields, @optional_fields)
      |> unique_constraint(:email)
  end

  def registration_changeset(model, params) do
    model
    |> cast(params, ~w(new_password), [])
    |> validate_length(:new_password, min: 6, max: 100)
    |> put_pass_hash()
    |> changeset(params)
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{new_password: pass}} ->
        put_change(changeset, :password, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
