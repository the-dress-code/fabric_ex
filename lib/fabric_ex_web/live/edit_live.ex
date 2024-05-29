defmodule FabricExWeb.EditLive do
  use FabricExWeb, :live_view

  alias FabricEx.Fabrics.Fabric
  alias FabricEx.Fabrics

  def render(assigns) do
    ~H"""
    <%!-- Edit Fabric Form --%>

    <.simple_form for={@form} phx-change="validate" phx-submit="save_fabric">
      <%= if @uploads.image.entries == [] do %>
        <%= if @form[:image].value do %>
          <img src={@form[:image].value} />
        <% else %>
          <.icon name="hero-user-solid" class="h-20 w-20 text-tertiary" />
        <% end %>
      <% else %>
        <.live_img_preview entry={List.first(@uploads.image.entries)} />
      <% end %>
      <div class="hidden">
        <.input field={@form[:image]} type="text" required />
      </div>
      <.label for={@uploads.image.ref}>Image</.label>

      <.live_file_input upload={@uploads.image} />
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
      <div class="hidden">
        <.input field={@form[:id]} type="text" label="Fabric ID" required />
        <.input field={@form[:user_id]} type="text" label="User ID" required />
      </div>
      <.button type="submit" phx-disable-with="Saving ...">Save Changes</.button>
    </.simple_form>
    """
  end

  def mount(params, _session, socket) do
    form =
      params
      |> Map.get("fabric_id")
      |> get_fabric
      |> Fabric.changeset(%{})
      |> to_form(as: "fabric")

    socket =
      socket
      |> assign(show_modal: false)
      |> assign(form: form)
      |> assign(page_title: "My Fabric Stash | Edit Fabric")

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
    IO.inspect(fabric_params: fabric_params)
    %{current_user: user} = socket.assigns

    socket =
      case Map.get(fabric_params, "id") do
        nil ->
          socket
          |> put_flash(:error, "Fabric not found")

        id ->
          fabric_id = String.to_integer(id)

          updated_fabric_params =
            fabric_params
            |> Map.put("id", fabric_id)
            |> Map.put("user_id", user.id)

            # if image is newly uploaded, set image to new value
            # otherwise, return updated fabric params with no change to image value
            # case based off list first consume files
            # if nil, return unaltered fabric params
            # if anything else, add value to image in params

            # could also make fn that does the case statement
            # and deals with updating or passing back unaltered fabric params (either override or give back)

            |> Map.put("image", List.first(consume_files(socket)))

          IO.inspect(updated_fabric_params: updated_fabric_params)

          case Fabrics.update(fabric_id, updated_fabric_params) do
            {:ok, _fabric} ->
              socket
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

  defp consume_files(socket) do
    consume_uploaded_entries(socket, :image, fn %{path: path}, _entry ->
      dest = Path.join([:code.priv_dir(:fabric_ex), "static", "uploads", Path.basename(path)])
      File.cp!(path, dest)
      {:ok, ~p"/uploads/#{Path.basename(dest)}"}
    end)
  end

  defp get_fabric(nil) do
    %Fabric{}
  end

  defp get_fabric("") do
    %Fabric{}
  end

  defp get_fabric(fabric_id) when is_binary(fabric_id) do
    case Integer.parse(fabric_id) do
      {fabric_id, _} ->
        get_fabric(fabric_id)

      :error ->
        %Fabric{}
    end
  end

  defp get_fabric(fabric_id) when is_integer(fabric_id) do
    case Fabrics.get_fabric(fabric_id) do
      nil ->
        %Fabric{}

      fabric ->
        fabric
    end
  end
end
