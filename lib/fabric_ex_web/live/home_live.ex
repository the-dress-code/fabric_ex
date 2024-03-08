defmodule FabricExWeb.HomeLive do
  use FabricExWeb, :live_view

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
        <tr>
          <th>
            <div class="flex items-center gap-3">
            <div class="fabric photo">
              <img src="https://fabrics-store.com/images/product/FS_F_19231680272071_1000x1000.jpg" alt="grey" />
            </div>
            </div>
          </th>
          <td>1</td>
          <td>medium</td>
          <td>grey</td>
          <td>midweight</td>
          <td>woven</td>
          <td>linen</td>
          <td>59"</td>
        </tr>
        <!-- row 2 -->
        <tr>
          <th>
            <div class="flex items-center gap-3">
            <div class="fabric photo">
              <img src="https://fabrics-store.com/images/product/FS_F_19231680272071_1000x1000.jpg" alt="grey" />
            </div>
          </div>
          </th>
          <td>1</td>
          <td>medium</td>
          <td>grey</td>
          <td>midweight</td>
          <td>woven</td>
          <td>linen</td>
          <td>59"</td>
        </tr>
        </tbody>
      </table>
      </div>
      """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
