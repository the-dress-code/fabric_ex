defmodule FabricExWeb.HomeLive do
  use FabricExWeb, :live_view

  alias FabricEx.Fabrics.Fabric
  alias FabricEx.Fabrics

  @impl true
  def render(assigns) do
    ~H"""
    <div class="py-4">
      <.button type="button" phx-click={show_modal("new-fabric-modal")}>
        Add Fabric
      </.button>
    </div>

    <.modal id="new-fabric-modal">
      <.simple_form for={@form} phx-change="validate" phx-submit="save_fabric">
        <.label for={@uploads.image.ref}>Image</.label>

        <.live_file_input upload={@uploads.image} required />
        <.input field={@form[:yards]} type="number" label="Yards" min=".25" step=".25" required />
        <.input field={@form[:shade]} type="text" label="Shade" required />
        <.input field={@form[:color]} type="text" label="Color" required />
        <.input field={@form[:weight]} type="text" label="Weight" required />
        <.input field={@form[:structure]} type="text" label="Structure" required />
        <.input field={@form[:content]} type="text" label="Content" required />
        <.input field={@form[:width]} type="number" label="Width" required />
        <.input field={@form[:item_number]} type="text" label="Item #" />
        <.button type="submit" phx-disable-with="Saving ...">Add Fabric</.button>
      </.simple_form>
    </.modal>

    <.table id="fabrics" rows={@fabrics}>
      <%!-- <:col :let={fabric} label="id"><%= fabric.id %></:col> --%>
      <:col :let={fabric} label="image"><img src={fabric.image} /></:col>
      <:col :let={fabric} label="yards"><%= fabric.yards %></:col>
      <:col :let={fabric} label="shade"><%= fabric.shade %></:col>
      <:col :let={fabric} label="color"><%= fabric.color %></:col>
      <:col :let={fabric} label="weight"><%= fabric.weight %></:col>
      <:col :let={fabric} label="structure"><%= fabric.structure %></:col>
      <:col :let={fabric} label="content"><%= fabric.content %></:col>
      <:col :let={fabric} label="width"><%= fabric.width %>"</:col>
      <:col :let={fabric} label="item #"><%= fabric.item_number %></:col>
      <%!-- <:col :let={fabric} label="user"><%= fabric.user_id %></:col> --%>
    </.table>

    <div class="grid grid-cols-1 sm:grid-cols-3 gap-3">
      <%= for fabric <- @fabrics do %>
        <div class="shadow-xl aspect-square">
          <img class="object-center h-full w-full rounded-lg" src={fabric.image} alt="Fabric" />
        </div>
      <% end %>
    </div>
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
      |> assign(page_title: "My Fabric Stash")
      |> assign(fabrics: Fabrics.list_fabrics(socket.assigns.current_user.id))
      |> allow_upload(:image, accept: ~w(.png .jpg), max_entries: 1)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"fabric" => fabric_params}, socket) do
    form =
      %Fabric{}
      |> Fabric.changeset(fabric_params)
      |> Map.put(:action, :validate)
      |> to_form(as: "fabric")

    {:noreply, socket |> assign(form: form)}
  end

  def handle_event("save_fabric", %{"fabric" => fabric_params}, socket) do
    %{current_user: user} = socket.assigns

    fabric_params
    |> Map.put("user_id", user.id)
    |> Map.put("image", List.first(consume_files(socket)))
    |> Fabrics.save()
    |> case do
      {:ok, _fabric} ->
        socket =
          socket
          |> put_flash(:info, "Fabric added successfully!")
          |> push_navigate(to: ~p"/home")

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> put_flash(:error, "Oops! Fabric not added yet..")

        {:noreply, socket}
    end
  end

  defp consume_files(socket) do
    consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
      dest = Path.join([:code.priv_dir(:fabric_ex), "static", "uploads", Path.basename(path)])
      File.cp!(path, dest)
      {:ok, ~p"/uploads/#{Path.basename(dest)}"}
    end)
  end
end
