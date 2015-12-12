defmodule Dots.Square do
  defstruct coordinates: %Dots.Coordinate{}, claims: [], completed_by: nil

  def claim(nil, _claim), do: {:error, nil}
  def claim({_, square}, claim), do: claim(square, claim)

  def claim(%{claims: claims} = square, %{position: position, player: player} = claim) do
    case taken_position?(claims, position) do
      true ->
        { :taken, square }
      false ->
        new_claims = [ claim | square.claims]
        case new_claims |> length do
          4 ->
            {
              :completed,
              %{square | claims: new_claims, completed_by: player}
            }
          _ ->
            {
              :ok,
              %{square | claims: new_claims}
            }
        end
    end
  end

  def new(x \\ 0, y \\ 0) do
    %__MODULE__{
      coordinates: %Dots.Coordinate{x: x, y: y}
    }
  end

  defp taken_position?(claims, position) do
    claims |> Enum.any? fn(claim) ->
      claim.position == position
    end
  end
end
