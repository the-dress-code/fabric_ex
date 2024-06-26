defmodule FabricExWeb.HomeLive do
  use FabricExWeb, :live_view

  alias Phoenix.LiveView.JS
  alias FabricEx.Fabrics.Fabric
  alias FabricEx.Fabrics
  alias FabricExWeb.FabricComponents

  @impl true
  def render(assigns) do
    ~H"""
    <%!-- Add Fabric button --%>

    <div class="py-2">
      <.button class="btn btn-neutral" type="button" phx-click={show_modal("new-fabric-modal")}>
        Add Fabric
      </.button>
    </div>

    <%!-- New Fabric Modal --%>

    <.modal id="new-fabric-modal">
      <.simple_form for={@form} phx-change="validate" phx-submit="save_fabric">
        <.label for={@uploads.image.ref}>Image</.label>

        <.live_file_input upload={@uploads.image} required />
        <.input field={@form[:yards]} type="number" label="Yards" min=".25" step=".25" required />
        <.input list="shade_list" field={@form[:shade]} type="search" label="Shade" required />
        <datalist id="shade_list">
          <%= for shade_option <- @shade_list do %>
            <option value={shade_option}></option>
          <% end %>
        </datalist>
        <.input list="color_list" field={@form[:color]} type="search" label="Color" required />
        <datalist id="color_list">
          <%= for color_option <- @color_list do %>
            <option value={color_option}></option>
          <% end %>
        </datalist>
        <.input list="weight_list" field={@form[:weight]} type="search" label="Weight" required />
        <datalist id="weight_list">
          <%= for weight_option <- @weight_list do %>
            <option value={weight_option}></option>
          <% end %>
        </datalist>
        <.input
          list="structure_list"
          field={@form[:structure]}
          type="search"
          label="Structure"
          required
        />
        <datalist id="structure_list">
          <%= for structure_option <- @structure_list do %>
            <option value={structure_option}></option>
          <% end %>
        </datalist>
        <.input list="content_list" field={@form[:content]} type="search" label="Content" required />
        <datalist id="content_list">
          <%= for content_option <- @content_list do %>
            <option value={content_option}></option>
          <% end %>
        </datalist>
        <.input field={@form[:width]} type="number" label="Width in Inches" required />
        <.input field={@form[:item_number]} type="text" label="Item #" />
        <.button class="btn btn-neutral" type="submit" phx-disable-with="Saving ...">
          Add Fabric
        </.button>
      </.simple_form>
    </.modal>

    <%!-- Table-View of All Fabrics --%>

    <.table
      id="fabrics"
      rows={@fabrics}
      row_click={fn row -> show_modal("fabric-details-modal-#{row.id}") end}
    >
      <:col :let={fabric} label="Image"><img src={fabric.image} /></:col>

      <:col :let={fabric} label="Yards"><%= fabric.yards %></:col>

      <:col :let={fabric} label="Shade"><%= fabric.shade %></:col>

      <:col :let={fabric} label="Color"><%= fabric.color %></:col>

      <:col :let={fabric} label="Weight"><%= fabric.weight %></:col>

      <:col :let={fabric} label="Structure"><%= fabric.structure %></:col>

      <:col :let={fabric} label="Content"><%= fabric.content %></:col>

      <:col :let={fabric} label="Width"><%= fabric.width %>"</:col>

      <:col :let={fabric} label="Item #"><%= fabric.item_number %></:col>

      <:action :let={fabric}>
        <.link
          id={"edit_icon_#{fabric.id}"}
          method="edit"
          phx-click="edit_fabric"
          phx-value-fabric-id={fabric.id}
        >
          <.icon name="hero-pencil" class="h-4 w-4" />
        </.link>
      </:action>
      <:action :let={fabric}>
        <.link
          method="delete"
          phx-click="delete_fabric"
          phx-value-fabric-id={fabric.id}
          data-confirm="Are you sure?"
        >
          <.icon name="hero-trash" class="h-4 w-4" />
        </.link>
      </:action>
    </.table>

    <%!-- Image-Grid-View of All Fabrics--%>

    <div class="grid grid-cols-1 sm:grid-cols-3 gap-3">
      <%= for fabric <- @fabrics do %>
        <div
          phx-click={show_modal("fabric-details-modal-#{fabric.id}")}
          class="shadow-xl aspect-square"
        >
          <img class="object-center h-full w-full rounded-lg" src={fabric.image} alt="Fabric" />
        </div>
      <% end %>
    </div>

    <%!-- Fabric Details Modal --%>

    <.modal :for={fabric <- @fabrics} id={"fabric-details-modal-#{fabric.id}"}>
      <div phx-click-away={hide_modal("fabric-details-modal-#{fabric.id}")}>
        <FabricComponents.details_card selected_fabric={fabric}>
          <:item title="Yards"><%= fabric.yards %></:item>
          <:item title="Shade"><%= fabric.shade %></:item>
          <:item title="Color"><%= fabric.color %></:item>
          <:item title="Weight"><%= fabric.weight %></:item>
          <:item title="Structure"><%= fabric.structure %></:item>
          <:item title="Content"><%= fabric.content %></:item>
          <:item title="Width"><%= fabric.width %></:item>
          <:item title="Item #"><%= fabric.item_number %></:item>
        </FabricComponents.details_card>
      </div>
    </.modal>
    """
  end

  def mount(_params, _session, socket) do
    form =
      %Fabric{}
      |> Fabric.changeset(%{})
      |> to_form(as: "fabric")

    fabrics = Fabrics.list_fabrics(socket.assigns.current_user.id)

    socket =
      socket
      |> assign(show_modal: false)
      |> assign(form: form)
      |> assign(page_title: "My Fabric Stash")
      |> assign(fabrics: fabrics)

      # Assigning Input Option Lists

      |> assign(
        shade_list: [
          "pastel",
          "light",
          "medium",
          "bright",
          "dark",
          "neon"
        ]
      )
      |> assign(
        color_list: [
          "blue",
          "green",
          "yellow",
          "orange",
          "red",
          "pink",
          "purple",
          "teal",
          "brown",
          "grey",
          "black",
          "white",
          "beige",
          "ivory"
        ]
      )
      |> assign(
        weight_list: [
          "lightweight",
          "midweight",
          "heavyweight"
        ]
      )
      |> assign(
        structure_list: [
          "woven",
          "knit",
          "nonwoven",
          "hide",
          "felt",
          "lace"
        ]
      )
      |> assign(
        content_list: [
          "nylon",
          "acetate",
          "acrylic",
          "polyester",
          "spandex",
          "lycra",
          "rayon",
          "viscose",
          "bamboo",
          "modal",
          "lyocell",
          "tencel",
          "cotton",
          "linen",
          "hemp",
          "silk",
          "wool",
          "leather",
          "fur",
          "vinyl"
        ]
      )
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
    IO.inspect(fabric_params: fabric_params)

    socket =
      case Map.get(fabric_params, "id") do
        nil ->
          fabric_params
          |> Map.put("user_id", user.id)
          |> Map.put("image", List.first(consume_files(socket)))
          |> Fabrics.save()
          |> case do
            {:ok, _fabric} ->
              socket
              |> update(:fabrics, fn fabrics ->
                fabrics ++ ["fabric"]
              end)
              |> put_flash(:info, "Fabric added successfully!")
              |> push_navigate(to: ~p"/home")

            {:error, changeset} ->
              IO.inspect(changeset)

              socket
              |> put_flash(:error, "Oops! Fabric not added yet..")
          end

        id ->
          fabric_id = String.to_integer(id)

          updated_fabric_params =
            fabric_params
            |> Map.put("id", fabric_id)
            |> Map.put("user_id", user.id)

          IO.inspect(updated_fabric_params: updated_fabric_params)

          fabric_id
          |> Fabrics.update(updated_fabric_params)
          |> case do
            {:ok, _fabric} ->
              socket
              |> update(:fabrics, fn fabrics ->
                fabrics ++ ["fabric"]
              end)
              |> put_flash(:info, "Fabric updated successfully!")
              |> push_navigate(to: ~p"/home")

            {:error, changeset} ->
              IO.inspect(changeset)

              socket
              |> put_flash(:error, "Oops! Fabric not updated...")
          end
      end

    {:noreply, socket}
  end

  def handle_event("delete_fabric", %{"fabric-id" => fabric_id}, socket) do
    %{current_user: user} = socket.assigns

    fabric_id = String.to_integer(fabric_id)

    case Fabrics.delete(fabric_id) do
      {:ok, _fabric} ->
        socket =
          socket
          |> update(:fabrics, fn fabrics ->
            Enum.reject(fabrics, fn fabric -> fabric.id == fabric_id end)
          end)
          |> put_flash(:info, "Fabric deleted successfully!")
          |> push_navigate(to: ~p"/home")

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> put_flash(:error, "Oops! Can't delete fabric...")

        {:noreply, socket}
    end
  end

  def handle_event("edit_fabric", %{"fabric-id" => fabric_id}, socket) do
    fabric_id = String.to_integer(fabric_id)

    socket =
      socket
      |> push_navigate(to: ~p"/fabrics/#{fabric_id}/edit")

    {:noreply, socket}
  end

  defp consume_files(socket) do
    consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
      dest = Path.join([:code.priv_dir(:fabric_ex), "static", "uploads", Path.basename(path)])
      File.cp!(path, dest)
      {:ok, ~p"/uploads/#{Path.basename(dest)}"}
    end)
  end
end
