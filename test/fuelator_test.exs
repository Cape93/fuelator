defmodule FuelatorTest do
  use ExUnit.Case
  doctest Fuelator

  describe "calculate_fuel/2" do
    test "returns valid result for launching" do
      assert Fuelator.calculate_fuel(28_801, [{:launch, 9.807}]) == 19_772
    end

    test "returns valid result for landing" do
      assert Fuelator.calculate_fuel(30_500, [{:land, 9.807}]) == 14_257
    end

    test "returns valid result for provided route" do
      assert Fuelator.calculate_fuel(42_135, [
               {:launch, 9.807},
               {:land, 3.711},
               {:launch, 3.711},
               {:land, 9.807}
             ]) == 99_016
    end

    test "returns error when flight route has to same directives in a row" do
      assert Fuelator.calculate_fuel(42_135, [
               {:launch, 9.807},
               {:land, 3.711},
               {:launch, 3.711},
               {:launch, 9.807}
             ]) == {:error, "Flight route can't have same directives in a row"}
    end

    test "returns error when mass is not in good format" do
      assert Fuelator.calculate_fuel("28801", [{:launch, 9.807}]) ==
               {:error, "Wrong type of argument mass with value \"28801\"."}
    end

    test "returns error when routes are not in good format" do
      assert Fuelator.calculate_fuel(28_801, {:land, 9.807}) ==
               {:error, "Routes are not in good format."}
    end

    test "returns error when route is not in good format" do
      assert Fuelator.calculate_fuel(28_801, [:launch]) ==
               {:error, "Route has to be tuple with 2 elements, got :launch."}
    end

    test "returns error when gravity is map" do
      assert Fuelator.calculate_fuel(28_801, [{:land, %{gravity: 9.807}}]) ==
               {:error, "Wrong type of argument gravity with value %{gravity: 9.807}."}
    end

    test "returns error when gravity is string" do
      assert Fuelator.calculate_fuel(28_801, [{:land, "9.807"}]) ==
               {:error, "Wrong type of argument gravity with value \"9.807\"."}
    end

    test "returns error for non-existing directive" do
      assert Fuelator.calculate_fuel(28_801, [{:jump, 9.807}]) ==
               {:error, "Unknown directive :jump"}
    end
  end
end
