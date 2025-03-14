defmodule NasaTest do
  use ExUnit.Case
  # doctest Nasa

  test "fuel by weight formula landing check" do
    assert Nasa.fuel_for_weight(28801, 9.807, :land) == 9278
  end

  test "fuel weight calculator" do
    assert Nasa.fuel_for_fuel(9278, 9.807, :land, 0) == 13447
  end

  test "Apollo 11 fuel weight requirement" do
    assert Nasa.total_fuel_required(28801, [{:launch, 9.807}, {:land, 1.62}, {:launch, 1.62}, {:land, 9.807}]) == 51898
  end

  test "Mars mission fuel weight requirement" do
    assert Nasa.total_fuel_required(14606, [{:launch, 9.807}, {:land, 3.711}, {:launch, 3.711}, {:land, 9.807}]) == 33388
  end

  test "Passenger ship fuel weight requirement" do
    assert Nasa.total_fuel_required(75432, [{:launch, 9.807}, {:land, 1.62}, {:launch, 1.62}, {:land, 3.711}, {:launch, 3.711}, {:land, 9.807}]) == 212161
  end
end
