# Fuelator

NASA software application for calculating fuel required for the flight.
The goal of this application is to calculate fuel to launch from one planet of the Solar system,
and to land on another planet of the Solar system, depending on the flight route.

The formula for fuel calculations for the launch is the following:

mass * gravity * 0.042 - 33 rounded down

The formula for fuel calculations for the landing is the following:

mass * gravity * 0.033 - 42 rounded down

But fuel adds weight to the ship, so it requires additional fuel, until additional fuel is 0 or negative.
Additional fuel is calculated using the same formula from above.


## Installation

You need to have:

Erlang/OTP 24 [erts-12.0.2] and Elixir - 1.12.1

To fetch dependencies:

```shell
mix deps.get
```

To run the application:

```shell
iex -S mix
```

To run the test suite :

```shell
mix test
```

### Examples of fuel calculations in interactive Elixir shell

```elixir
iex> Fuelator.calculate_fuel 28801, [{:launch, 9.807}, {:land, 1.62}, {:launch, 1.62}, {:land, 9.807}]
51898

iex> Fuelator.calculate_fuel 14606, [{:launch, 9.807}, {:land, 3.711}, {:launch, 3.711}, {:land, 9.807}]
33388

iex> Fuelator.calculate_fuel 75432, [{:launch, 9.807}, {:land, 1.62}, {:launch, 1.62}, {:land, 3.711}, {:launch, 3.711}, {:land, 9.807}]
212161
```
