defmodule Dots.GameScorerTest do
  use ExUnit.Case, async: true

  test ".score calculates score based on player name" do
    {_, board} = Dots.Board.new(width: 2, height: 2)
    |> claim(0, 0, "Josh")
    |> claim(1, 0, "Josh")
    |> claim(0, 1, "Joe")
    |> claim(1, 1, "Joe")

    game = %{players: ["Josh", "Joe"]}
    assert Dots.GameScorer.score(game, board) == %{
      winners: ["Josh", "Joe"],
      scores: %{
        "Josh" => 2,
        "Joe" => 2,
      }
    }
  end

  defp claim({_result, board}, x, y, player), do: claim(board, x, y, player)
  defp claim(board, x, y, player) do
    coordinates = %Dots.Coordinate{x: x, y: y}

    board
    |> Dots.Board.claim(coordinates, %{player: player, position: "Top"})
    |> Dots.Board.claim(coordinates, %{player: player, position: "Left"})
    |> Dots.Board.claim(coordinates, %{player: player, position: "Right"})
    |> Dots.Board.claim(coordinates, %{player: player, position: "Bottom"})
  end
end
