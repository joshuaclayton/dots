defmodule Dots.Player do
  defstruct id: 0, name: "New player", active: true

  def new(player_name) when is_binary(player_name) do
    new(%{name: player_name, id: generate_id})
  end

  def new(attributes) when is_map(attributes) do
    %__MODULE__{}
    |> Map.merge(attributes)
  end

  defp generate_id do
    UUID.uuid4()
  end
end
