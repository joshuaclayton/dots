defmodule Dots.Lobby do
  defstruct game: nil, status: :not_started, width: 0, height: 0

  def new(lobby \\ %__MODULE__{}) do
    %{lobby | game: Dots.Game.new}
  end

  def add_player(%{game: game} = lobby, player) do
    %{lobby |
      game: %{game | players: game.players ++ [player]}}
  end

  def remove_player(%{game: game} = lobby, player) do
    %{lobby |
      game: %{game | players: game.players |> List.delete(player)}}
  end

  def choose_dimensions(lobby, width, height) do
    %{lobby | width: width, height: height}
  end

  def start(%{game: game} = lobby) do
    %{lobby |
      status: :started,
      game: Dots.Game.start(game, players: [], width: lobby.width, height: lobby.height)}
  end
end
