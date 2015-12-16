defmodule Dots.BoardTest do
  use ExUnit.Case, async: true

  test ".new creates a new board with the correct squares" do
    board = Dots.Board.new(width: 2, height: 2)

    assert board.squares |> length == 4
    assert board.width == 2
    assert board.height == 2
  end

  test ".claim claims the appropriate squares" do
    {:ok, updated_board} = Dots.Board.new(width: 2, height: 1)
                           |> Dots.Board.claim(%Dots.Coordinate{x: 0, y: 0}, %{player: "Erin", position: "Right"})

    assert updated_board.squares == [
      %Dots.Square{coordinates: %Dots.Coordinate{x: 0, y: 0}, claims: [%{player: "Erin", position: "Right"}]},
      %Dots.Square{coordinates: %Dots.Coordinate{x: 1, y: 0}, claims: [%{player: "Erin", position: "Left"}]}
    ]
  end

  test ".claim claims on a boundary" do
    {:ok, updated_board} = Dots.Board.new(width: 2, height: 1)
                    |> Dots.Board.claim(%Dots.Coordinate{x: 1, y: 0}, %{player: "Erin", position: "Right"})

    assert updated_board.squares == [
      %Dots.Square{coordinates: %Dots.Coordinate{x: 0, y: 0}, claims: []},
      %Dots.Square{coordinates: %Dots.Coordinate{x: 1, y: 0}, claims: [%{player: "Erin", position: "Right"}]}
    ]
  end

  test ".claim completes" do
    {:completed, updated_board} = Dots.Board.new(width: 1, height: 1)
                                  |> Dots.Board.claim(%Dots.Coordinate{x: 0, y: 0}, %{player: "Erin", position: "Top"})
                                  |> Dots.Board.claim(%Dots.Coordinate{x: 0, y: 0}, %{player: "Erin", position: "Right"})
                                  |> Dots.Board.claim(%Dots.Coordinate{x: 0, y: 0}, %{player: "Erin", position: "Left"})
                                  |> Dots.Board.claim(%Dots.Coordinate{x: 0, y: 0}, %{player: "Erin", position: "Bottom"})

    assert (updated_board.squares |> Enum.at(0)).claims |> length == 4

    assert updated_board |> Dots.Board.is_completed? == true
  end

  test ".claim sorts squares" do
    {:ok, updated_board} = Dots.Board.new(width: 3, height: 3)
                           |> Dots.Board.claim(%Dots.Coordinate{x: 1, y: 0}, %{player: "Erin", position: "Left"})
                           |> Dots.Board.claim(%Dots.Coordinate{x: 2, y: 2}, %{player: "Erin", position: "Right"})

    assert updated_board.squares == [
      %Dots.Square{coordinates: %Dots.Coordinate{x: 0, y: 0}, claims: [%{player: "Erin", position: "Right"}]},
      %Dots.Square{coordinates: %Dots.Coordinate{x: 1, y: 0}, claims: [%{player: "Erin", position: "Left"}]},
      %Dots.Square{coordinates: %Dots.Coordinate{x: 2, y: 0}, claims: []},
      %Dots.Square{coordinates: %Dots.Coordinate{x: 0, y: 1}, claims: []},
      %Dots.Square{coordinates: %Dots.Coordinate{x: 1, y: 1}, claims: []},
      %Dots.Square{coordinates: %Dots.Coordinate{x: 2, y: 1}, claims: []},
      %Dots.Square{coordinates: %Dots.Coordinate{x: 0, y: 2}, claims: []},
      %Dots.Square{coordinates: %Dots.Coordinate{x: 1, y: 2}, claims: []},
      %Dots.Square{coordinates: %Dots.Coordinate{x: 2, y: 2}, claims: [%{player: "Erin", position: "Right"}]}
    ]
  end
end
