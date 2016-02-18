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
      game: %{game | players: game.players |> mark_players_inactive_by_identifier(identifier)}}
  end

  def rejoin_player(%{game: game} = lobby, identifier) do
    %{lobby |
      game: %{game | players: game.players |> mark_players_active_by_identifier(identifier)}}
  end

  def choose_dimensions(lobby, width, height) do
    %{lobby | width: width, height: height}
  end

  def start(%{game: game} = lobby) do
    %{lobby |
      status: :started,
      game: Dots.Game.start(game, players: [], width: lobby.width, height: lobby.height)}
  end

  defp mark_players_inactive_by_identifier(players, identifier) do
    player_index = players |> Enum.find_index(fn player ->
      player.name == identifier || player.id == identifier
    end)

    update_player_state_at_index players, %{ active: false }, player_index
  end

  defp mark_players_active_by_identifier(players, identifier) do
    player_index = players |> Enum.find_index(fn player ->
      player.name == identifier || player.id == identifier
    end)

    update_player_state_at_index players, %{ active: true }, player_index
  end

  defp update_player_state_at_index(players, _, nil), do: players
  defp update_player_state_at_index(players, state, player_index) do
    players |> List.update_at(player_index, fn player -> Map.merge(player, state) end)
  end
end
