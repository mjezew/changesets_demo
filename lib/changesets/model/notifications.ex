defmodule Changesets.Model.Notifications do
  use Ecto.Schema
  import Ecto.Changeset
  alias Changesets.Model.User

  schema "notifications" do
    field :billing, :boolean
    field :marketing, :boolean
    field :strategy, :boolean

    belongs_to :user, User
    timestamps()
  end

  @type t :: %__MODULE__{
          id: String.t(),
          user_id: String.t(),
          billing: boolean,
          marketing: boolean,
          strategy: boolean
        }

  @spec create_changeset(t(), map()) :: Ecto.Changeset.t(t())
  def create_changeset(_notifs, attrs) do
    %__MODULE__{billing: true, marketing: true, strategy: true}
    |> cast(attrs, [:billing, :marketing, :strategy])
    |> validate_required([:billing, :marketing, :strategy])
  end

  @spec update_changeset(t(), map()) :: Ecto.Changeset.t(t())
  def update_changeset(notifs, attrs) do
    notifs
    |> cast(attrs, [:billing, :marketing, :strategy])
    |> validate_required([:billing, :marketing, :strategy])
  end

  @spec update_changeset(t(), map()) :: Ecto.Changeset.t(t())
  def transfer_ownership_changeset(notifs, _attrs) do
    notifs
    |> change(billing: true)
    |> change(strategy: true)
    |> change(marketing: false)
  end
end
