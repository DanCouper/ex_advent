defmodule Day01Bench do
  use Benchfella
  alias ExAdvent.Day01

  @input_list Day01.clean_sequence()

  def first_repeated_ets(input_list) do
    :ets.new(:hash, [:named_table, :set, :private])

    input_list
    |> Stream.cycle()
    |> Enum.reduce_while({0, :ets.insert(:hash, {0, nil})}, fn f, {acc, _} ->
      acc = acc + f

      case :ets.lookup(:hash, acc) do
        [] ->
          {:cont, {acc, :ets.insert(:hash, {acc, nil})}}

        [_] ->
          :ets.delete(:hash)
          {:halt, acc}
      end
    end)
  end

  def first_repeated_set(input_list) do
    input_list
    |> Stream.cycle()
    |> Enum.reduce_while({0, MapSet.new([0])}, fn f, {acc, set} ->
      acc = acc + f

      case MapSet.member?(set, acc) do
        false -> {:cont, {acc, MapSet.put(set, acc)}}
        true -> {:halt, acc}
      end
    end)
  end

  bench "ets" do
    first_repeated_ets(@input_list)
  end

  bench "set" do
    first_repeated_set(@input_list)
  end
end
