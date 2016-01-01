defmodule Dots.Game do
  import Dots.GameScorer, only: [score: 2]

  defstruct board: nil, players: [], turns: [], current_player: 0, completed: false, score: %{}

  def new do
    %__MODULE__{}
  end

  def start(game \\ %__MODULE__{}, players: players, width: width, height: height) do
    %{game |
      players: players ++ game.players,
      board: Dots.Board.new(width: width, height: height),
      turns: Stream.cycle(players ++ game.players) |> Enum.take((2*width+1)*height+width)
    }
  end

  def current_player(game) do
    game.turns |> Enum.at(game.current_player)
  end

  def players_names(players) do
    players |> Enum.map &(&1.name)
  end

  def claim(%{completed: true, score: score}, _, _, _) do
    IO.puts "Game is done!"
    IO.inspect score
  end

  def claim(game, x, y, position) do
    {result, new_board} = game.board
                          |> Dots.Board.claim(%Dots.Coordinate{x: x, y: y}, %{position: position, player: game |> current_player})

    case result do
      :completed ->
        %{game | score: score(game, new_board), completed: new_board |> Dots.Board.is_completed?, board: new_board, current_player: game.current_player }
      :taken ->
        %{game | score: score(game, new_board), board: new_board, current_player: game.current_player }
      _ ->
        %{game | score: score(game, new_board), board: new_board, current_player: game.current_player+1 }
    end
  end
end
