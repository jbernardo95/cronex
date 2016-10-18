defmodule Cronex.Master do
  @moduledoc """
  This module represents the master server which is responsible for adding (starting) and removing (stopping) jobs.
  """
  use GenServer

  # Interface functions
  
  def start_link(state, opts \\ []) do
    GenServer.start_link(__MODULE__, state, opts)
  end


  # Callbacks

  def init(_) do
    # get jobs from config
    {:ok, nil}
  end

  # add job
  # remove job
end
