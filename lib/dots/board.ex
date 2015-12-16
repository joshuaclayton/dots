defmodule Dots.Board do
  @adjacent_positions %{
    "Left"   => %{x: -1, y: 0, position: "Right"},
    "Right"  => %{x: 1, y: 0, position: "Left"},
    "Top"    => %{x: 0, y: 1, position: "Bottom"},
    "Bottom" => %{x: 0, y: -1, position: "Top"}
  }

  defstruct width: 0, height: 0, squares: []

  def new([width: width, height: height]) do
    squares = (1..width |> Enum.map fn(x) ->
      1..height |> Enum.map fn(y) ->
        build_square x - 1, y - 1
      end
    end) |> List.flatten

    %__MODULE__{
      width: width,
      height: height,
      squares: squares
    }
  end

  def claim({_, board}, coordinate, claim), do: claim(board, coordinate, claim)
  def claim(board, coordinate, %{position: position} = claim) do
    {primary_result, primary_square} = board
                     |> find_square(coordinate)
                     |> Dots.Square.claim(claim)

    %{x: delta_x, y: delta_y, position: delta_position} = @adjacent_positions[position]

    {secondary_result, secondary_square} = board
                       |> find_square(%Dots.Coordinate{x: coordinate.x+delta_x, y: coordinate.y+delta_y})
                       |> Dots.Square.claim(%{claim | position: delta_position})

    new_squares = board
                  |> squares_without_coordinates([primary_square, secondary_square] |> Enum.reject fn(x) -> is_nil(x) end)
                  |> sort_squares

    {
      final_result([primary_result, secondary_result]),
      %{board | squares: new_squares}
    }
  end

  def is_completed?(board) do
    board.squares
    |> Enum.all? fn(square) ->
      !is_nil(square.completed_by)
    end
  end

  defp final_result(results) do
    cond do
      Enum.member?(results, :completed) -> :completed
      Enum.member?(results, :taken) -> :taken
      Enum.member?(results, :ok) -> :ok
    end
  end

  defp squares_without_coordinates({_, board}, removed_squares), do: squares_without_coordinates(board, removed_squares)

  defp squares_without_coordinates(%{squares: squares}, removed_squares) do
    (
      squares
      |> Enum.reject fn(square) ->
        removed_squares
        |> Enum.map(fn(%{coordinates: coordinates}) -> coordinates end)
        |> Enum.member? square.coordinates
      end
    ) ++ removed_squares
  end

  defp sort_squares(squares) do
    squares
    |> Enum.group_by(fn square -> square.coordinates.y end)
    |> Enum.map(fn {y, squares_array} ->
      %{}
      |> Map.put(y,
        squares_array |> Enum.sort(fn a, b ->
          a.coordinates.x <= b.coordinates.x
        end)
      )
    end)
    |> Enum.reduce(&Map.merge/2)
    |> Map.values
    |> List.flatten
  end

  defp build_square(x, y) do
    Dots.Square.new(x, y)
  end

  defp find_square({_, board}, coordinate), do: find_square(board, coordinate)
  defp find_square(%{squares: squares}, coordinate) do
    squares
    |> Enum.find fn(square) ->
      square.coordinates == coordinate
    end
  end
end
