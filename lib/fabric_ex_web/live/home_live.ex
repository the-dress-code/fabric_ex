defmodule FabricExWeb.HomeLive do
  use FabricExWeb, :live_view

  @impl true
  def render(assigns) do
      ~H"""
      <h1 class="text-2xl">Fabric Stash</h1>
      """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
