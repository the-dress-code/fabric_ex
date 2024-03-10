defmodule FabricExWeb.HomeLive do
  use FabricExWeb, :live_view
  alias FabricEx.Fabric

  @impl true
  def render(assigns) do
      ~H"""
      <h1 class="text-2xl">Fabric Stash</h1>

      <div class="overflow-x-auto">
        <table class="table">
        <!-- head -->
          <thead>
            <tr>
              <th>image</th>
              <th>yards</th>
              <th>shade</th>
              <th>color</th>
              <th>weight</th>
              <th>structure</th>
              <th>content</th>
              <th>width</th>
            </tr>
          </thead>
        <tbody>
        <!-- row 1 -->
        <%= for fabric <- @fabrics do %>
          <tr>
            <td><img src={fabric.image} /></td>
            <td><%= fabric.yards %></td>
            <td><%= fabric.shade %></td>
            <td><%= fabric.color %></td>
            <td><%= fabric.weight %></td>
            <td><%= fabric.structure %></td>
            <td><%= fabric.content %></td>
            <td><%= fabric.width %>"</td>
          </tr>
        <% end %>
        </tbody>
      </table>
      </div>
      """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket,
      fabrics: FabricEx.Repo.all(Fabric)
  )}
  end
end
