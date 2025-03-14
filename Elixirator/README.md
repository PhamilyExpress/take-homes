# Nasa

To run, cd into file with mix.exs then type in the command line

```
mix run -e "IO.puts(Nasa.total_fuel_required(weight, instructions))"
```

For example:

```
mix run -e "IO.puts(Nasa.total_fuel_required(28801, [{:launch, 9.807}, {:land, 1.62}, {:launch, 1.62}, {:land, 9.807}]))"
```
