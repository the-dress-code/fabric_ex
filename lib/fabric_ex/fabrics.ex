defmodule FabricEx.Fabrics do
  import Ecto.Query, warn: false
  alias FabricEx.Repo
  alias FabricEx.Fabric

  def list_fabrics do
    query =
      from p in Fabric,
        select: p,
        order_by: [desc: :inserted_at],
        preload: [:user]

    Repo.all(query)
  end

  def save(fabric_params) do
    %Fabric{}
    |> Fabric.changeset(fabric_params)
    |> Repo.insert()
  end
end
