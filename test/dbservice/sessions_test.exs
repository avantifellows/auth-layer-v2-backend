defmodule Dbservice.SessionsTest do
  use Dbservice.DataCase

  alias Dbservice.Sessions

  describe "session" do
    alias Dbservice.Sessions.Session

    import Dbservice.SessionsFixtures

    @invalid_attrs %{end_time: nil, meta_data: nil, name: nil, portal_link: nil, repeat_till_date: nil, repeat_type: nil, start_time: nil, type: nil, type_uid: nil}

    test "list_session/0 returns all session" do
      session = session_fixture()
      assert Sessions.list_session() == [session]
    end

    test "get_session!/1 returns the session with given id" do
      session = session_fixture()
      assert Sessions.get_session!(session.id) == session
    end

    test "create_session/1 with valid data creates a session" do
      valid_attrs = %{end_time: ~U[2022-04-28 13:58:00Z], meta_data: %{}, name: "some name", portal_link: "some portal_link", repeat_till_date: ~U[2022-04-28 13:58:00Z], repeat_type: "some repeat_type", start_time: ~U[2022-04-28 13:58:00Z], type: "some type", type_uid: "some type_uid"}

      assert {:ok, %Session{} = session} = Sessions.create_session(valid_attrs)
      assert session.end_time == ~U[2022-04-28 13:58:00Z]
      assert session.meta_data == %{}
      assert session.name == "some name"
      assert session.portal_link == "some portal_link"
      assert session.repeat_till_date == ~U[2022-04-28 13:58:00Z]
      assert session.repeat_type == "some repeat_type"
      assert session.start_time == ~U[2022-04-28 13:58:00Z]
      assert session.type == "some type"
      assert session.type_uid == "some type_uid"
    end

    test "create_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sessions.create_session(@invalid_attrs)
    end

    test "update_session/2 with valid data updates the session" do
      session = session_fixture()
      update_attrs = %{end_time: ~U[2022-04-29 13:58:00Z], meta_data: %{}, name: "some updated name", portal_link: "some updated portal_link", repeat_till_date: ~U[2022-04-29 13:58:00Z], repeat_type: "some updated repeat_type", start_time: ~U[2022-04-29 13:58:00Z], type: "some updated type", type_uid: "some updated type_uid"}

      assert {:ok, %Session{} = session} = Sessions.update_session(session, update_attrs)
      assert session.end_time == ~U[2022-04-29 13:58:00Z]
      assert session.meta_data == %{}
      assert session.name == "some updated name"
      assert session.portal_link == "some updated portal_link"
      assert session.repeat_till_date == ~U[2022-04-29 13:58:00Z]
      assert session.repeat_type == "some updated repeat_type"
      assert session.start_time == ~U[2022-04-29 13:58:00Z]
      assert session.type == "some updated type"
      assert session.type_uid == "some updated type_uid"
    end

    test "update_session/2 with invalid data returns error changeset" do
      session = session_fixture()
      assert {:error, %Ecto.Changeset{}} = Sessions.update_session(session, @invalid_attrs)
      assert session == Sessions.get_session!(session.id)
    end

    test "delete_session/1 deletes the session" do
      session = session_fixture()
      assert {:ok, %Session{}} = Sessions.delete_session(session)
      assert_raise Ecto.NoResultsError, fn -> Sessions.get_session!(session.id) end
    end

    test "change_session/1 returns a session changeset" do
      session = session_fixture()
      assert %Ecto.Changeset{} = Sessions.change_session(session)
    end
  end

  describe "session_occurence" do
    alias Dbservice.Sessions.SessionOccurence

    import Dbservice.SessionsFixtures

    @invalid_attrs %{end_time: nil, start_time: nil}

    test "list_session_occurence/0 returns all session_occurence" do
      session_occurence = session_occurence_fixture()
      assert Sessions.list_session_occurence() == [session_occurence]
    end

    test "get_session_occurence!/1 returns the session_occurence with given id" do
      session_occurence = session_occurence_fixture()
      assert Sessions.get_session_occurence!(session_occurence.id) == session_occurence
    end

    test "create_session_occurence/1 with valid data creates a session_occurence" do
      valid_attrs = %{end_time: ~U[2022-04-28 14:05:00Z], start_time: ~U[2022-04-28 14:05:00Z]}

      assert {:ok, %SessionOccurence{} = session_occurence} = Sessions.create_session_occurence(valid_attrs)
      assert session_occurence.end_time == ~U[2022-04-28 14:05:00Z]
      assert session_occurence.start_time == ~U[2022-04-28 14:05:00Z]
    end

    test "create_session_occurence/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sessions.create_session_occurence(@invalid_attrs)
    end

    test "update_session_occurence/2 with valid data updates the session_occurence" do
      session_occurence = session_occurence_fixture()
      update_attrs = %{end_time: ~U[2022-04-29 14:05:00Z], start_time: ~U[2022-04-29 14:05:00Z]}

      assert {:ok, %SessionOccurence{} = session_occurence} = Sessions.update_session_occurence(session_occurence, update_attrs)
      assert session_occurence.end_time == ~U[2022-04-29 14:05:00Z]
      assert session_occurence.start_time == ~U[2022-04-29 14:05:00Z]
    end

    test "update_session_occurence/2 with invalid data returns error changeset" do
      session_occurence = session_occurence_fixture()
      assert {:error, %Ecto.Changeset{}} = Sessions.update_session_occurence(session_occurence, @invalid_attrs)
      assert session_occurence == Sessions.get_session_occurence!(session_occurence.id)
    end

    test "delete_session_occurence/1 deletes the session_occurence" do
      session_occurence = session_occurence_fixture()
      assert {:ok, %SessionOccurence{}} = Sessions.delete_session_occurence(session_occurence)
      assert_raise Ecto.NoResultsError, fn -> Sessions.get_session_occurence!(session_occurence.id) end
    end

    test "change_session_occurence/1 returns a session_occurence changeset" do
      session_occurence = session_occurence_fixture()
      assert %Ecto.Changeset{} = Sessions.change_session_occurence(session_occurence)
    end
  end
end
