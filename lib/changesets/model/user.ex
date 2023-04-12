defmodule Changesets.Model.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Changesets.Model.Notifications

  @email_regex ~r/^[\w.!#$%&’*+\-\/=?\^`{|}~]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]{2,})$/i

  schema "users" do
    field :email, :string
    field :name, :string
    field :nick_name, :string
    field :age, :integer
    field :role, :string

    has_one :notifications, Notifications, on_replace: :update

    timestamps()
  end

  @type t :: %__MODULE__{
          id: String.t(),
          email: String.t(),
          name: String.t() | nil,
          nick_name: String.t() | nil,
          role: String.t() | nil,
          notifications: Notifications.t()
        }

  @spec create_changeset(%__MODULE__{}, map()) :: Ecto.Changeset.t(t())
  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :nick_name, :email, :age])
    |> validate_format(:email, @email_regex, message: "invalid email")
    |> validate_required(:email, message: "email is required")
    |> validate_inclusion(:age, 20..150)
    |> validate_change(:nick_name, &no_capitals/2)
    |> cast_assoc(:notifications, with: &Notifications.create_changeset/2, required: true)
  end

  @spec customize_profile_changeset(%__MODULE__{}, map()) :: Ecto.Changeset.t(t())
  def customize_profile_changeset(user, attrs) do
    cast(user, attrs, [:name, :age, :nick_name])
  end

  @spec transfer_ownership_changeset(%__MODULE__{}, map()) :: Ecto.Changeset.t(t())
  def transfer_ownership_changeset(user, _attrs) do
    user
    |> change(role: :owner)
    |> cast_embed(:notifications, with: &Notifications.transfer_ownership_changeset/2)
  end

  @spec revoke_ownership_changeset(%__MODULE__{}, map()) :: Ecto.Changeset.t(t())
  def revoke_ownership_changeset(user, attrs) do
    user
    |> cast(attrs, [:role])
    |> cast_embed(:notifications, with: &Notifications.update_changeset/2)
  end

  defp no_capitals(:nick_name, name) do
    if String.downcase(name) == name do
      []
    else
      [nick_name: "Cannot be capitalized"]
    end
  end
end
