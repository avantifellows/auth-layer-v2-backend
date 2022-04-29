defmodule Dbservice.Sessions.Session do
  use Ecto.Schema
  import Ecto.Changeset

  schema "session" do
    field :end_time, :utc_datetime
    field :meta_data, :map
    field :name, :string
    field :portal_link, :string
    field :repeat_till_date, :utc_datetime
    field :repeat_type, :string
    field :start_time, :utc_datetime
    field :type, :string
    field :type_uid, :string
    field :owner_id, :id
    field :created_by_id, :id

    timestamps()
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:name, :type, :type_uid, :portal_link, :start_time, :end_time, :repeat_type, :repeat_till_date, :meta_data])
    |> validate_required([:name, :type, :type_uid, :portal_link, :start_time, :end_time, :repeat_type, :repeat_till_date, :meta_data])
  end
end
