defmodule MusicDB.Repo.Migrations.AddCompositionsTable do
  use Ecto.Migration

  def change do
    create table("compositions") do
      add :title, :string, null: false
      add :year, :integer, null: false
      add :artist_id, references("artists"), null: false
      timestamps()
      # timestamps(inserted_at: :created_at, updated_at: :changes_at,
      #   type: :utc_datetime)
    end
  end
end
