defmodule Fuelator do
  @moduledoc """
  Module for calculating fuel required for the flight.
  """

  @type mass :: integer() | float()

  @doc """
  Complete fuel calculation for given mass and flight routes.

  ## Examples

      iex> Fuelator.calculate_fuel 28801, [{:launch, 9.807}, {:land, 1.62}, {:launch, 1.62}, {:land, 9.807}]
      51898

      iex> Fuelator.calculate_fuel 14606, [{:launch, 9.807}, {:land, 3.711}, {:launch, 3.711}, {:land, 9.807}]
      33388

      iex> Fuelator.calculate_fuel 75432, [{:launch, 9.807}, {:land, 1.62}, {:launch, 1.62}, {:land, 3.711}, {:launch, 3.711}, {:land, 9.807}]
      212161

  """
  @spec calculate_fuel(mass(), list()) :: integer() | {:error, String.t()}
  def calculate_fuel(mass, routes) when is_list(routes) do
    routes
    |> Enum.reverse()
    |> Enum.reduce_while({:none, mass, 0}, fn
      {directive, gravity}, {previous_directive, new_mass, acc} ->
        case do_calculation(directive, previous_directive, new_mass, gravity) do
          {:error, _reason} = error ->
            {:halt, error}

          fuel ->
            required_fuel = additional_fuel(directive, fuel, fuel, gravity)
            {:cont, {directive, new_mass + required_fuel, required_fuel + acc}}
        end

      route, _ ->
        {:halt, {:error, "Route has to be tuple with 2 elements, got #{inspect(route)}."}}
    end)
    |> case do
      {:error, _reason} = error -> error
      {_previous_directive, _new_mass, fuel} -> fuel
    end
  end

  def calculate_fuel(_mass, _routes) do
    {:error, "Routes are not in good format."}
  end

  defp do_calculation(directive, directive, _mass, _gravity) do
    {:error, "Flight route can't have same directives in a row"}
  end

  defp do_calculation(directive, _previous_directive, mass, gravity) do
    do_calculation(directive, mass, gravity)
  end

  defp do_calculation(directive, mass, gravity) do
    with {:ok, mass} <- parse_to_decimal(:mass, mass),
         {:ok, gravity} <- parse_to_decimal(:gravity, gravity) do
      calculation_formula(directive, mass, gravity)
    else
      error -> error
    end
  end

  defp calculation_formula(:launch, mass, gravity) do
    mass
    |> Decimal.mult(gravity)
    |> Decimal.mult("0.042")
    |> Decimal.sub("33")
    |> Decimal.round(0, :floor)
    |> Decimal.to_integer()
  end

  defp calculation_formula(:land, mass, gravity) do
    mass
    |> Decimal.mult(gravity)
    |> Decimal.mult("0.033")
    |> Decimal.sub("42")
    |> Decimal.round(0, :floor)
    |> Decimal.to_integer()
  end

  defp calculation_formula(directive, _mass, _gravity) do
    {:error, "Unknown directive #{inspect(directive)}"}
  end

  defp additional_fuel(directive, fuel, more_fuel, gravity) do
    more_fuel = do_calculation(directive, more_fuel, gravity)

    if more_fuel > 0 do
      additional_fuel(directive, fuel + more_fuel, more_fuel, gravity)
    else
      fuel
    end
  end

  defp parse_to_decimal(_arg_name, value) when is_integer(value) do
    {:ok, Decimal.new(value)}
  end

  defp parse_to_decimal(_arg_name, value) when is_float(value) do
    {:ok, Decimal.from_float(value)}
  end

  defp parse_to_decimal(arg_name, value) do
    {:error, "Wrong type of argument #{arg_name} with value #{inspect(value)}."}
  end
end
