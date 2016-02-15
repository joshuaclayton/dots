defmodule Dots.GameScorer do
  def score(game, board) do
    %{
      scores: scores(game, board),
      winners: winners(game, board)
    }
  end

  defp winners(game, board) do
    scores(game, board)
    |> Enum.group_by(fn {_name, score} -> score end)
    |> Enum.max_by(fn {score, _players} -> score end)
    |> extract_scores
  end

  defp extract_scores({_top_score, players}) do
    players
    |> Enum.map(fn {name, _score} -> name end)
  end

  defp scores(game, board) do
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
      case completed_by do
        nil -> result
        _ -> Dict.put result, completed_by, value + 1
      end
    end)
  end
end
