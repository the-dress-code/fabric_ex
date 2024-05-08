defmodule FabricExWeb.FabricComponents do
  use Phoenix.Component
  use FabricExWeb, :html

  def details_card(assigns) do
    ~H"""
    <div class="card card-side bg-base-80 shadow-xl">
      <figure><img src={@selected_fabric.image} /></figure>
      <div class="card-body">
        <dl class="-my-4 divide-y divide-zinc-100">
          <div :for={item <- @item} class="flex gap-4 py-4 text-sm leading-6 sm:gap-8">
            <dt class="w-1/4 flex-none text-zinc-500"><%= item.title %></dt>
            <dd class="text-zinc-700"><%= render_slot(item) %></dd>
          </div>
        </dl>

        <%!-- <div class="card-actions justify-end">
          <button class="btn btn-primary">Edit</button>
        </div>
        <div class="card-actions justify-end">
          <button class="btn btn-primary">Delete</button>
        </div> --%>
      </div>
    </div>
    """
  end

  def edit_details_card(assigns) do
    ~H"""
    <.simple_form for={@form} phx-change="validate" phx-submit="save_fabric">
      <img src={@form[:image].value} />
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
      <.button type="submit" phx-disable-with="Saving ...">Add Fabric</.button>
    </.simple_form>
    """
  end
end
