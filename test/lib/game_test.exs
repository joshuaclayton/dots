defmodule Dots.GameTest do
  use ExUnit.Case, async: true

  test ".start starts a game" do
    game = Dots.Game.start(players: ["Joe", "Erin", "Amy"], width: 2, height: 2)
    assert game.turns |> length == 12

    assert game |> Dots.Game.current_player == "Joe"

    game = game |> Dots.Game.claim 0, 0, "Top"

    assert game |> Dots.Game.current_player == "Erin"

    game = game |> Dots.Game.claim 0, 0, "Right"

    assert game |> Dots.Game.current_player == "Amy"

    game = game |> Dots.Game.claim 0, 0, "Bottom"

    assert game |> Dots.Game.current_player == "Joe"

    game = game |> Dots.Game.claim 0, 0, "Left"

    assert game |> Dots.Game.current_player == "Joe"

    game = game |> Dots.Game.claim 1, 0, "Left" # taken

    assert game |> Dots.Game.current_player == "Joe"

    game = game |> Dots.Game.claim 1, 0, "Bottom"

    assert game |> Dots.Game.current_player == "Erin"
  end

  test ".start starts a game and is completed" do
    game = Dots.Game.start(players: ["Joe", "Erin"], width: 1, height: 1)
    result = game
             |> Dots.Game.claim(0, 0, "Top")
             |> Dots.Game.claim(0, 0, "Right")
             |> Dots.Game.claim(0, 0, "Bottom")
             |> Dots.Game.claim(0, 0, "Left")

    assert result.completed == true
    assert result.score == %{"Erin" => 1, "Joe" => 0}
  end
end
