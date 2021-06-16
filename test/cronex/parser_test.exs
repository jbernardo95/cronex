defmodule Cronex.ParserTest do
  use ExUnit.Case
  doctest Cronex.Parser, except: [parse_interval_frequency: 3]

  test "parse_interval_frequency/2" do
    assert {0, interval_fn, :*, :*, :*} = Cronex.Parser.parse_interval_frequency(2, :hour)
    assert 0 == interval_fn.(0)
    assert 0 == interval_fn.(2)
    assert 0 == interval_fn.(4)
    assert 1 == interval_fn.(3)
  end

  test "parse_interval_frequency/3" do
    assert {10, 12, interval_fn, :*, :*} =
             Cronex.Parser.parse_interval_frequency(4, :day, "12:10")

    assert 0 == interval_fn.(0)
    assert 0 == interval_fn.(4)
    assert 0 == interval_fn.(8)
    assert 2 == interval_fn.(2)
  end

  test "parse_regular_frequency/2" do
    assert {0, 0, :*, :*, day_frequency} = Cronex.Parser.parse_regular_frequency(:monday, "00:00")
    assert 1 == day_frequency

    assert {30, 10, :*, :*, days_frequency} =
             Cronex.Parser.parse_regular_frequency([:friday, :saturday], "10:30")

    assert [5, 6] == days_frequency
  end
end
