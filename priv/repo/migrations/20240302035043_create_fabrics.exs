defmodule FabricEx.Repo.Migrations.CreateFabrics do
  use Ecto.Migration

  def change do
    create table(:fabrics) do
      add :shade, :string
      add :color, :string
      add :weight, :string
      add :content, :string
      add :structure, :string
      add :width, :integer
      add :yards, :float
      add :item_number, :string
      add :image, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end
  end
end
