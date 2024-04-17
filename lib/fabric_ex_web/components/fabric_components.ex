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
end
