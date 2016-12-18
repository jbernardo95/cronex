defmodule Cronex.DateTime do
  @moduledoc"""
  This module is an extention of the elixir DateTime module.

  This will module will be deprecated as soon as Elixir 1.4 is out.
  """

  defstruct year: 0,
            month: 0,
            day: 0,
            hour: 0,
            minute: 0,
            second: 0,
            day_of_the_week: 0 

  @doc"""
  Returns current date and time as a `%Cronex.DateTime{}`.

  ## Example
  
      iex> current_date_time = Cronex.DateTime.current
      iex> current_date_time.hour > 0
      true
  """
  def current do
    current_date_time = DateTime.utc_now
    current_day_of_the_week = current_date_time |> DateTime.to_date |> Date.to_erl |> :calendar.day_of_the_week

    %Cronex.DateTime{year: current_date_time.year,
                     month: current_date_time.month,
                     day: current_date_time.day,
                     hour: current_date_time.hour,
                     minute: current_date_time.minute,
                     second: current_date_time.second,
                     day_of_the_week: current_day_of_the_week}
  end
end
