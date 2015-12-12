defmodule Dots.SquareTest do
  use ExUnit.Case, async: true

  test ".claim marks a square for a player in a position" do
    square = Dots.Square.new(5, 2)

    {:ok, updated_square} = square
                            |> Dots.Square.claim(%{player: "Joe", position: "Top"})
                            |> Dots.Square.claim(%{player: "Mary", position: "Left"})
                            |> Dots.Square.claim(%{player: "Erin", position: "Right"})

    assert updated_square.coordinates.x == 5
    assert updated_square.coordinates.y == 2
    assert updated_square.claims == [
      %{player: "Erin", position: "Right"},
      %{player: "Mary", position: "Left"},
      %{player: "Joe", position: "Top"}
    ]
  end

  test ".claim handles nil squares" do
    {:error, result} = nil |> Dots.Square.claim(%{player: "Joe", position: "Top"})

    assert result == nil
  end

  test ".claim returns a taken notification when a position is already taken" do
    square = Dots.Square.new(5, 2)

    {:taken, updated_square} = square
                               |> Dots.Square.claim(%{player: "Joe", position: "Top"})
                               |> Dots.Square.claim(%{player: "Joe", position: "Top"})
                               |> Dots.Square.claim(%{player: "Jane", position: "Left"})
                               |> Dots.Square.claim(%{player: "Erin", position: "Top"})

    assert updated_square.coordinates.x == 5
    assert updated_square.coordinates.y == 2
    assert updated_square.claims == [
      %{player: "Jane", position: "Left"},
      %{player: "Joe", position: "Top"}
    ]
  end

  test ".claim tracks completed squares" do
    square = Dots.Square.new(5, 2)

    {:completed, updated_square} = square
                               |> Dots.Square.claim(%{player: "Joe", position: "Top"})
                               |> Dots.Square.claim(%{player: "Joe", position: "Right"})
                               |> Dots.Square.claim(%{player: "Jane", position: "Bottom"})
                               |> Dots.Square.claim(%{player: "Erin", position: "Left"})

    assert updated_square.coordinates.x == 5
    assert updated_square.coordinates.y == 2
    assert updated_square.claims == [
      %{player: "Erin", position: "Left"},
      %{player: "Jane", position: "Bottom"},
      %{player: "Joe", position: "Right"},
      %{player: "Joe", position: "Top"},
    ]
    assert updated_square.completed_by == "Erin"
  end
end
