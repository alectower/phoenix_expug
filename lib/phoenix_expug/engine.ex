defmodule PhoenixExpug.Engine do
  @moduledoc ~S"""
  Phoenix template engine for Expug.
  """

  @behaviour Phoenix.Template.Engine

  @expug_options [
    raw_helper: "raw",
    escape_helper: ""
  ]

  alias Expug.Error

  @doc """
  Precompiles the String file_path into a function defintion, using Calliope engine
  """
  def compile(path, _name) do
    path
    |> read!
    |> EEx.compile_string(engine: Phoenix.HTML.Engine, file: path, line: 1)
  end

  defp read!(file_path) do
    try do
      file_path |> File.read! |> Expug.to_eex!(@expug_options)
    rescue
      error in [Error] ->
        reraise %Error{error |
          message: "#{file_path}: " <> error.message}, __STACKTRACE__
      error ->
        reraise error, __STACKTRACE__
    end

  end
end
