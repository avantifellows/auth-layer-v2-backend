defmodule Dbservice.Repo.Migrations.CreateProgramTable do
  use Ecto.Migration

  def change do
    create table(:program) do
      add :name, :string
      add :program_type, :string
      add :program_sub_type, :string
      add :program_mode, :string
      add :program_start_date, :date
      add :program_target_outreach, :integer
      add :program_product_used, :string
      add :program_donor, :string
      add :program_state, :string

      timestamps()
    end
  end
end