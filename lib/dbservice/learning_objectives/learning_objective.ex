defmodule Dbservice.LearningObjectives.LearningObjective do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Dbservice.Concepts.Concept
  alias Dbservice.Resources.Resource

  schema "learning_objective" do
    field(:title, {:array, :map})

    timestamps()

    has_many(:resource, Resource)
    belongs_to(:concept, Concept)
  end

  @doc false
  def changeset(learning_objective, attrs) do
    learning_objective
    |> cast(attrs, [
      :title,
      :concept_id
    ])
  end
end
