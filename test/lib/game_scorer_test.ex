defmodule Dots.GameScorerTest do
  use ExUnit.Case, async: true

  test ".score calculates score based on player name" do
    board = Dots.Board.new(width: 5, height: 5)

    squares = board.squares
              |> Enum.map fn(square) ->
                %{square | completed_by: "Josh"}
              end

    assert %{board | squares: squares} |> Dots.GameBoard.score == %{
      "Josh" => 25
    }
  end
end
