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

  def get_fabric(nil) do
    %Fabric{}
  end

  def get_fabric(fabric_id) when is_integer(fabric_id) do
    Repo.get(Fabric, fabric_id)
  end

  def save(fabric_params) do
    %Fabric{}
    |> Fabric.changeset(fabric_params)
    |> Repo.insert()
  end

  def update(fabric_id, fabric_params) when is_integer(fabric_id) do
    fabric = Repo.get(Fabric, fabric_id)
    # IO.inspect(fabric: fabric)
    fabric_changeset = Fabric.changeset(fabric, fabric_params)
    # IO.inspect(fabric_changeset: fabric_changeset)
    Repo.update(fabric_changeset)
  end

  def delete(fabric_id) when is_integer(fabric_id) do
    Repo.get(Fabric, fabric_id)
    |> Repo.delete()
  end
end
