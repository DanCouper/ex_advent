defmodule ExAdvent.Day02 do
  @moduledoc """
  # Day 2: Inventory Management System

  You stop falling through time, catch your breath, and check the screen on the device. "Destination reached. Current Year: 1518. Current Location: North Pole Utility Closet 83N10." You made it! Now, to find those anomalies.

  Outside the utility closet, you hear footsteps and a voice. "...I'm not sure either. But now that so many people have chimneys, maybe he could sneak in that way?" Another voice responds, "Actually, we've been working on a new kind of suit that would let him fit through tight spaces like that. But, I heard that a few days ago, they lost the prototype fabric, the design plans, everything! Nobody on the team can even seem to remember important details of the project!"

  "Wouldn't they have had enough fabric to fill several boxes in the warehouse? They'd be stored together, so the box IDs should be similar. Too bad it would take forever to search the warehouse for two similar box IDs..." They walk too far away to hear any more.
  """

  @input_path Path.join(:code.priv_dir(:ex_advent), "day_02_input")

  def clean_sequence(input_path \\ @input_path) do
    input_path
    |> File.stream!()
    |> Stream.map(&String.trim_trailing(&1))
    |> Enum.into([])
  end

  @doc """
  Late at night, you sneak to the warehouse - who knows what kinds of paradoxes you could cause if you were discovered - and use your fancy wrist device to quickly scan every box and produce a list of the likely candidates (your puzzle input).

  To make sure you didn't miss any, you scan the likely candidate boxes again, counting the number that have an ID containing exactly two of any letter and then separately counting those with exactly three of any letter. You can multiply those two counts together to get a rudimentary checksum and compare it to what your device predicts.

  For example, if you see the following box IDs:

    abcdef contains no letters that appear exactly two or three times.
    bababc contains two a and three b, so it counts for both.
    abbcde contains two b, but no letter appears exactly three times.
    abcccd contains three c, but no letter appears exactly two times.
    aabcdd contains two a and two d, but it only counts once.
    abcdee contains two e.
    ababab contains three a and three b, but it only counts once.

  Of these box IDs, four of them contain a letter which appears exactly twice, and three of them contain a letter which appears exactly three times. Multiplying these together produces a checksum of 4 * 3 = 12.

  What is the checksum for your list of box IDs?
  """
  def calculate_checksum(input_list) do
    {p, t} =
      input_list
      |> Stream.map(&letter_count(&1, %{}))
      |> Stream.map(fn counts ->
        # FIXME I hate this
        {Enum.count(counts, fn c -> c == 2 end), Enum.count(counts, fn c -> c == 3 end)}
      end)
      |> Enum.reduce({0, 0}, fn {p, t}, {pairs, triplets} ->
        {pairs + p, triplets + t}
      end)

    # FIXME This was not necessary for my input, but I would
    # like to integrate this a bit better with above.
    {p, t} =
      case {p, t} do
        {0, t} when t > 0 -> {1, t}
        {p, 0} when p > 0 -> {p, 1}
        _ -> {p, t}
      end

    p * t
  end

  def letter_count(<<>>, map) do
    map
    |> Map.values()
    # FIXME can I do most of the work here to get a
    # useful output - {pair, triplet} as {0 or 1, 0 or 1}
    # would be ideal
    |> Enum.uniq()
  end

  def letter_count(<<hd, tl::binary>>, map) do
    case Map.has_key?(map, <<hd>>) do
      true -> letter_count(tl, Map.update!(map, <<hd>>, &(&1 + 1)))
      false -> letter_count(tl, Map.put(map, <<hd>>, 1))
    end
  end

  @doc """
  # Part Two

  Confident that your list of box IDs is complete, you're ready to find the boxes full of prototype fabric.

  The boxes will have IDs which differ by exactly one character at the same position in both strings. For example, given the following box IDs:

    abcde
    fghij
    klmno
    pqrst
    fguij
    axcye
    wvxyz

  The IDs abcde and axcye are close, but they differ by two characters (the second and fourth). However, the IDs fghij and fguij differ by exactly one character, the third (h and u). Those must be the correct boxes.

  What letters are common between the two correct box IDs? (In the example above, this is found by removing the differing character from either ID, producing fgij.)
  """
  def common_letters(input_list) do
    input_list
    |> create_pairings()
    |> Enum.reduce_while("", fn {a, b}, _ ->
      case String.myers_difference(a, b) do
        [eq: common_a, del: <<_diff_a::8>>, ins: <<_diff_b::8>>, eq: common_b] ->
          {:halt, common_a <> common_b}

        _ ->
          {:cont, ""}
      end
    end)
  end

  def create_pairings(input_list) do
    for id_a <- input_list,
        id_b <- input_list,
        id_a != id_b,
        do: {id_a, id_b}
  end
end
