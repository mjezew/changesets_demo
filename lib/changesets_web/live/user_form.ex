defmodule ChangesetsWeb.Live.ProfileForm do
  use ChangesetsWeb, :live_view

  alias Changesets.Model.User

  @spec render(map) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
      <.form :let={f} for={@form} phx-change="validate" phx-submit="submit" id="user-form" class="flex flex-col">
        <.input field={@form[:age]} label="Age"/>
        <.input field={@form[:name]} label="Name"/>
        <.input field={@form[:nick_name]} label="Nickname"/>
        <.input field={@form[:email]} label="Email"/>
        <div class="m-3">
          <p>Notification preferences</p>
          <.inputs_for :let={fp} field={f[:notifications]}>
            <.input type="checkbox" field={fp[:billing]} label="Billing"/>
            <.input type="checkbox" field={fp[:marketing]} label="Marketing"/>
            <.input type="checkbox" field={fp[:strategy]} label="Strategy"/>
          </.inputs_for>
        </div>
        <button type="submit" form="user-form" class="mt-3 border border-black rounded max-w-[80px]">
          Submit
        </button>
      </.form>
    """
  end

  @spec mount(map, map, Phoenix.LiveView.Socket.t()) :: {:ok, Phoenix.LiveView.Socket.t()}
  def mount(_params, _session, socket) do
    form = 
      %User{}
      |> User.create_changeset(%{})
      |> to_form()

    {:ok, assign(socket, form: form)}
  end

  def handle_event("validate", %{"user" => params}, socket) do
    form =
      %User{}
      |> User.create_changeset(params)
      |> Map.put(:action, :validate)
      |> IO.inspect()
      |> to_form()

    {:noreply, assign(socket, form: form)}
  end

  @spec handle_event(String.t(), map(), Phoenix.LiveView.Socket.t()) :: {:noreply, Phoenix.LiveView.Socket.t()}
  def handle_event("submit", %{"user" => _params}, socket) do
    with %Ecto.Changeset{valid?: true} <- socket.assigns.form.source do
      # MAKE API CALL
      {:noreply, socket}
    end
  end
end
