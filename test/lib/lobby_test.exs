defmodule Dots.LobbyTest do
  use ExUnit.Case, async: true

  test ".add_player adds a player to a game" do
    lobby = Dots.Lobby.new
            |> Dots.Lobby.add_player("Joe")
            |> Dots.Lobby.add_player("Jane")
            |> Dots.Lobby.add_player(%{name: "Jane", id: "abc-def"})

    assert lobby.game.players |> length == 3
  end

  test ".remove_player removes a player from the game" do
    lobby = Dots.Lobby.new
            |> Dots.Lobby.add_player("Joe")
            |> Dots.Lobby.add_player(%{name: "Jim", id: "abc-def"})
            |> Dots.Lobby.add_player("Jane")
            |> Dots.Lobby.remove_player("abc-def")
            |> Dots.Lobby.remove_player("Jane")

    assert Dots.Game.players_names(lobby.game) == ["Joe"]
  end

  test ".start starts the game" do
    lobby = Dots.Lobby.new

    assert lobby.status == :not_started

    lobby = lobby
            |> Dots.Lobby.add_player("Joe")
            |> Dots.Lobby.add_player("Erin")
            |> Dots.Lobby.add_player("Mary")
            |> Dots.Lobby.choose_dimensions(10, 5)
            |> Dots.Lobby.start

    assert lobby.status == :started
    assert (lobby.game.turns |> Enum.at(0)).name == "Joe"
    assert (lobby.game.turns |> Enum.at(1)).name == "Erin"
    assert (lobby.game.turns |> Enum.at(2)).name == "Mary"
    assert lobby.game.board.width == 10
    assert lobby.game.board.height == 5
  end
end
