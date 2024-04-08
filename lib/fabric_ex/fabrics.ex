defmodule FabricEx.Fabrics do
  import Ecto.Query, warn: false
  alias FabricEx.Repo
  alias FabricEx.Fabrics.Fabric

  def list_fabrics do
    query =
      from p in Fabric,
        select: p,
        order_by: [desc: :inserted_at],
        preload: [:user]

    Repo.all(query)
  end

  def list_fabrics(user_id) when is_integer(user_id) do
    query =
      from p in Fabric,
        select: p,
        where: p.user_id == ^user_id,
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
