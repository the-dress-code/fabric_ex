defmodule FabricEx.Repo.Migrations.FabricsAlterUserIdColumn do
  use Ecto.Migration

  def change do
    alter table(:fabrics) do
      modify :user_id, references(:users)
    end
  end
end
