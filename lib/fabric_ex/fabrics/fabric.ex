defmodule FabricEx.Fabrics.Fabric do
  use Ecto.Schema
  import Ecto.Changeset

  alias FabricEx.Accounts.User

  schema "fabrics" do
    field :image, :string
    field :width, :integer
    field :color, :string
    field :shade, :string
    field :weight, :string
    field :content, :string
    field :structure, :string
    field :yards, :float
    field :item_number, :string
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(fabric, attrs) do
    fabric
    |> cast(attrs, [
      :shade,
      :color,
      :weight,
      :content,
      :structure,
      :width,
      :yards,
      :item_number,
      :image,
      :user_id
    ])
    |> validate_required([
      :shade,
      :color,
      :weight,
      :content,
      :structure,
      :width,
      :yards,
      :item_number,
      :image,
      :user_id
    ])
  end
end
