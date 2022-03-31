defmodule Dbservice.GroupsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Dbservice.Groups` context.
  """

  @doc """
  Generate a group.
  """
  def group_fixture(attrs \\ %{}) do
    {:ok, group} =
      attrs
      |> Enum.into(%{
        input_schema: %{},
        locale: "some locale",
        locale_data: %{}
      })
      |> Dbservice.Groups.create_group()

    group
  end
end
