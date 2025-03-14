defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  @spec count(list) :: non_neg_integer
  def count(l) do
    count_recursion(l, 0)
  end

  def count_recursion([head | tail], acc) do
    count_recursion(tail, acc + 1)
  end

  def count_recursion([], acc), do: acc

  @spec reverse(list) :: list
  def reverse(l) do
    r_list = []
    reverse_list(l, r_list)
  end

  def reverse_list([head | tail], acc) do
    reverse_list(tail, [head | acc])
  end

  def reverse_list([], acc), do: acc

  @spec map(list, (any -> any)) :: list
  def map(l, f) do
    map_implementation(l, f, [])
  end

  def map_implementation([head | tail], f, acc) do
    result = f.(head)
    map_implementation(tail, f, [result | acc])
  end

  def map_implementation([], f, acc), do: acc |> reverse()

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f) do
    filter_recur(l, f, [])
  end

  def filter_recur([head | tail], f, acc) do
    if f.(head) do
      filter_recur(tail, f, [head | acc])
    else
      filter_recur(tail, f, acc)
    end
  end

  def filter_recur([], f, acc), do: acc |> reverse()

  @type acc :: any
  @spec foldl(list, acc, (any, acc -> acc)) :: acc
  def foldl(l, acc, f) do
    fold_recur(l, acc, f)
  end

  def fold_recur([head | tail], acc, f) do
    fold_recur(tail, f.(head, acc), f)
  end

  def fold_recur([], acc, f), do: acc

  @spec foldr(list, acc, (any, acc -> acc)) :: acc
  def foldr(l, acc, f) do
    foldl(reverse(l), acc, f)
  end

  @spec append(list, list) :: list
  def append(a, b) do
    append_recur(reverse(a), b)
  end

  def append_recur([head | tail], b) do
    append_recur(tail, [head | b])
  end

  def append_recur(a, []) do
    a
  end

  def append_recur([], b) do
    b
  end

  @spec concat([[any]]) :: [any]
  def concat(ll) do
    foldl(reverse(ll), [], &append(&1, &2))
  end
end
