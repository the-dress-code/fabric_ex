defmodule FabricExWeb.HomeLive do
  use FabricExWeb, :live_view

  alias FabricEx.Fabrics.Fabric

  @impl true
  def render(assigns) do
    ~H"""
    <h1 class="text-2xl">Fabric Stash</h1>
    <.button type="button" phx-click={show_modal("new-fabric-modal")}>Add Fabric</.button>

    <.modal id="new-fabric-modal">
      <.simple_form for={@form} phx-change="validate" phx-submit="save-fabric">
        <.live_file_input upload={@uploads.image} required />
        <.input field={@form[:shade]} type="textarea" label="Shade" required />
        <.input field={@form[:color]} type="textarea" label="Color" required />
        <.button type="submit" phx-disable-with="Saving ...">Add Fabric</.button>
      </.simple_form>
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    form =
      %Fabric{}
      |> Fabric.changeset(%{})
      |> to_form(as: "fabric")

    socket =
      socket
      |> assign(form: form)
      |> allow_upload(:image, accept: ~w(.png .jpg), max_entries: 1)

    {:ok, socket}
    # {:ok,
    #  assign(socket,
    #    fabrics: FabricEx.Repo.all(Fabric)
    #  )}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("save-fabric", %{"fabric" => fabric_params}, socket) do
    %{current_user: user} = socket.assigns

    fabric_params
    |> Map.put("user-id", user.id)
    |> Map.put("image_path", List.first(consume_files(socket)))
    |> Fabrics.save()
    |> case do
      {:ok, _fabric} ->
        socket =
          socket
          |> put_flash(:info, "Fabric added successfully!")
          |> push_navigate(to: ~p"/home")

        {:noreply, socket}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  defp consume_files(socket) do
    consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
      dest = Path.join([:code.priv_dir(:fabric_ex), "static", "uploads", Path.basename(path)])
      File.cp!(path, dest)
      {:postpone, ~p"/uploads/#Path.basename(dest)}"}
    end)
  end
end
