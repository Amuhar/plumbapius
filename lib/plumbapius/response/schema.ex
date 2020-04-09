defmodule Plumbapius.Response.Schema do
  @moduledoc "Describes the response schema for validation"

  @enforce_keys [:status, :content_type, :body]
  defstruct [:status, :content_type, :body]

  @typedoc "Response Schema"
  @type t :: %__MODULE__{
          status: String.t(),
          content_type: String.t(),
          body: ExJsonSchema.Schema.Root.t()
        }

  @doc """
  Returns a response scheme created from a tomogram.

  ## Parameters

    - tomogram: Description of the response scheme as a hash.

  ## Examples

      iex> Plumbapius.Response.Schema.new(%{
      ...>   "status" => "200",
      ...>   "content-type" => "application/json",
      ...>   "body" => %{
      ...>     "$schema" => "http://json-schema.org/draft-04/schema#",
      ...>     "type" => "object",
      ...>     "properties" => %{"msisdn" => %{"type" => "number"}},
      ...>     "required" => ["msisdn"]
      ...>   }
      ...> })
      %Plumbapius.Response.Schema{
        status: "200",
        content_type: "application/json",
        body: %ExJsonSchema.Schema.Root{
          custom_format_validator: nil,
          location: :root,
          refs: %{},
          schema: %{
            "$schema" => "http://json-schema.org/draft-04/schema#",
            "type" => "object",
            "properties" => %{"msisdn" => %{"type" => "number"}},
            "required" => ["msisdn"]
          }
        }
      }

  """
  @spec new(map()) :: t()
  def new(tomogram) when is_map(tomogram) do
    %__MODULE__{
      status: Map.fetch!(tomogram, "status"),
      content_type: Map.fetch!(tomogram, "content-type"),
      body: Map.fetch!(tomogram, "body") |> ExJsonSchema.Schema.resolve()
    }
  end
end
