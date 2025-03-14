defmodule Nasa do
  @moduledoc """
  Documentation for Elixirator submission.
  """

  @doc """
  Since we can't refuel, we need to work backwards and start with the last directive to calculate total fuel required.
  Using head tail pattern matching, we recursively calculate the total fuel required. Taking each directive, we calculate
  the fuel required for just the weight of the ship. Then we calculate the additional fuel required for inital fuel.
  We add the result together (including the ship weight), then we use the new weight for the next directive. This continues
  until we run out of directive. Finally, we remove the ship weight from our answer to get our final fuel cost.
  """
  def total_fuel_required(ship_weight, instructions) do
    reverse_instructions = Enum.reverse(instructions)
    total_weight = total_fuel_calculator(reverse_instructions, ship_weight)
    (total_weight - ship_weight)
  end

  def total_fuel_calculator([{directive, gravity} | tail], current_weight) do
    required_fuel = fuel_for_weight(current_weight, gravity, directive)
    new_fuel_weight = fuel_for_fuel(required_fuel, gravity, directive, 0)

    total_fuel_calculator(tail, current_weight + new_fuel_weight)
  end

  def total_fuel_calculator([], current_weight) do
    current_weight
  end

  @doc """
  Takes the mass, gravity, and directive and returns the rounded down value of the fuel required.
  Since landing and launching require different numbers, directive is use to determine the necessary value.
  """
  def fuel_for_weight(mass, gravity, directive) do
    [multiplier, subtractor] =
      case directive do
        :land -> [0.033, 42]
        :launch -> [0.042, 33]
      end

    floor((mass * gravity * multiplier) - subtractor)
  end

  @doc """
  Uses recursion to calculate additional fuel required. The function stops running when the fuel value is negative.
  At that point, the accumulator is returned, which contains the additional required fuel.
  """
  def fuel_for_fuel(required_fuel, gravity, directive, acc) when required_fuel > 0 do
    new_fuel_value = fuel_for_weight(required_fuel, gravity, directive)
    fuel_for_fuel(new_fuel_value, gravity, directive, acc + required_fuel)
  end

  def fuel_for_fuel(_fuel, _gravity, _directive, acc) do
    acc
  end
end
