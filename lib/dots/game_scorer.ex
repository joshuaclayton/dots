defmodule Dots.GameScorer do
  def score(game, board) do
    game.players
    |> Enum.reduce(Map.new, &default_score/2)
    |> Map.merge(score_board(board))
  end

  defp default_score(player, acc) do
    Dict.put acc, player, 0
  end

  defp score_board(board) do
    board.squares
    |> Enum.reduce(Map.new, fn(%{completed_by: completed_by}, result) ->
      value = Dict.get result, completed_by, 0
      Dict.put result, completed_by, value + 1
    end)
  end
end
