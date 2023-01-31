defmodule FrameTakehome do
  @moduledoc """
  Documentation for Frame.io take-home fact engine assignment.

  TODOs:
  - better error validation
  - clean up messy areas
  - better documentation
  """

  def read_file(file) do
    case File.read(file) do
      {:ok, file_contents} ->
        commands = String.split(file_contents, "\n")
        get_individual_commands(commands, [])

      {:error, error} ->
        IO.puts("error: file does not exist")
        {:error, error}
    end
  end

  def get_individual_commands([head | tail], acc) do
    acc = execute_command(head, acc)
    get_individual_commands(tail, acc)
  end

  def get_individual_commands([], acc), do: acc

  def execute_command("", acc), do: acc

  def execute_command(command, acc) do
    # splits the command into no more than three parts (to account for case where there are more than one param)
    args = String.split(command, " ", parts: 3)
    func_match(args, acc)
  end

  def func_match([head | tail], acc) do
    fact = hd(tail)
    # the tail of 'tail' is the param(s)
    [param] = tl(tail)
    param = param |> String.replace("(", "") |> String.replace(")", "")

    # if param has ',' then it has more than 1 params and is split into a list of the params
    param =
      if String.contains?(param, ", ") do
        String.split(param, ", ")
      else
        [param]
      end

    func(head, fact, param, acc)
  end

  def func_match(_, acc), do: acc

  def func("INPUT", fact, param, acc) do
    acc ++ [[fact, param]]
  end

  def func("QUERY", _fact, _param, []) do
    IO.puts("---\nfalse")
    []
  end

  def func("QUERY", fact, param, acc) do
    # the assumption here is that the first letter of the placeholder is a capital letter
    has_placeholder? = Enum.any?(param, fn x -> String.match?(x, ~r/^[A-Z]/) end)

    case has_placeholder? do
      true -> placeholder_query(acc, param, fact)
      false -> non_placeholder_query(acc, param, fact)
    end
  end

  def placeholder_query(acc, param, fact) do
    placeholder = Enum.filter(param, fn x -> String.match?(x, ~r/^[A-Z]/) end)
    non_placeholder_vals = Enum.filter(param, fn x -> String.match?(x, ~r/^[a-z0-9]/) end)

    # returns a list of items where the fact matches and the non-placeholder params matches with the param in the acc
    # (this is to get the correct query)
    matched_query =
      Enum.filter(acc, fn x ->
        [stored_fact, stored_params] = x

        stored_fact == fact && Enum.all?(non_placeholder_vals, fn x -> x in stored_params end)
      end)

    IO.puts("---")

    if matched_query == [], do: IO.puts("false")
    return_result(matched_query, non_placeholder_vals, placeholder, acc)
  end

  def return_result([head | tail], non_placeholder_vals, placeholder, acc) do
    # head tail match to bind the placeholder to the correct value that was inputed
    [arg] = tl(head)

    bind_placeholder(arg, placeholder, non_placeholder_vals)

    IO.write("\n")

    return_result(tail, non_placeholder_vals, placeholder, acc)
  end

  def return_result([], _, _, acc), do: acc

  def bind_placeholder(arg, placeholder, non_placeholder_vals) do
    binded = []
    placeholder = Enum.with_index(placeholder)

    # rejects any values that are not placeholders
    arg = Enum.reject(arg, fn x -> x in non_placeholder_vals end)

    # adds to 'bind' the placeholder with its corresponding value based on position in the query list
    binded =
      for n <- placeholder do
        binded ++ [elem(n, 0), Enum.at(arg, elem(n, 1))]
      end

    binded = remove_dupe(binded, []) |> Enum.uniq()

    # if false isn't in 'binded' then there are no errors and the program can print the results normally
    if false not in binded do
      for bind <- binded do
        output(bind)
      end
    else
      # there is a bug here that causes false to be printed twice if using the fourth provided test case
      IO.write("false")
    end
  end

  def output([head | [tail]]) do
    IO.write("#{head}: #{tail} ")
  end

  def remove_dupe([head | tail], acc) do
    # TODO: this function is messy and can be better optimised, which was not done because of time constraints.

    # loops through every placeholder and checks if the current placeholder matches:
    # a) if both placeholders varible and the value match, then the query matches multiple of the same placeholder and we continue
    # b) if the placeholders variable and value doesn't match, then the query matches different placeholders and we continue
    # c) if the placeholder variable matches but the value doesn't, then we have multiple same placeholders but they have different valules,
    # therefore the query doesn't match with what was inputed. The function returns false and we continue
    # d) reached the end of the list, we continue
    removed_dupes =
      if tail == [] do
        [head]
      else
        for n <- tail do
          cond do
            Enum.at(head, 0) == Enum.at(n, 0) && Enum.at(head, 1) != Enum.at(n, 1) ->
              false

            head == n || head != n ->
              head

            n == [] ->
              head
          end
        end
      end

    remove_dupe(tail, acc ++ removed_dupes)
  end

  def remove_dupe([], acc) do
    acc
  end

  def non_placeholder_query(acc, param, fact) do
    result =
      case Enum.find(acc, fn x -> x == [fact, param] end) do
        nil -> false
        _ -> true
      end

    IO.puts("---\n#{result}")
    acc
  end
end
