defmodule Dots.Lobby do
  defstruct game: nil, status: :not_started, width: 0, height: 0

  def new(lobby \\ %__MODULE__{}) do
    %{lobby | game: Dots.Game.new}
  end

  def add_player(%{game: game} = lobby, player) do
    %{lobby |
      game: %{game | players: game.players ++ [Dots.Player.new(player)]}}
  end

  def remove_player(%{game: game} = lobby, identifier) do
    %{lobby |
      game: %{game | players: game.players |> reject_players_by_identifier(identifier)}}
  end

  def choose_dimensions(lobby, width, height) do
    %{lobby | width: width, height: height}
  end

  def start(%{game: game} = lobby) do
    %{lobby |
      status: :started,
      game: Dots.Game.start(game, players: [], width: lobby.width, height: lobby.height)}
  end

  defp reject_players_by_identifier(players, identifier) do
    players
    |> Enum.reject(fn player ->
      player.name == identifier || player.id == identifier
    end)
  end
end
