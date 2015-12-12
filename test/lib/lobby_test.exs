defmodule Dots.LobbyTest do
  use ExUnit.Case, async: true

  test ".add_player adds a player to a game" do
    lobby = Dots.Lobby.new
            |> Dots.Lobby.add_player("Joe")
            |> Dots.Lobby.add_player("Jane")

    assert lobby.game.players |> length == 2
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
    assert lobby.game.turns |> Enum.at(0) == "Joe"
    assert lobby.game.turns |> Enum.at(1) == "Erin"
    assert lobby.game.turns |> Enum.at(2) == "Mary"
    assert lobby.game.board.width == 10
    assert lobby.game.board.height == 5
  end
end
