defmodule FakePlug do
  alias Plumbapius.Request
  alias Plumbapius.Response

  @spec call(atom | nil, any, function, function) :: any
  def call(:request_error, _opts, handle_request_error, _handle_response_error) do
    handle_request_error.(request_error())
  end

  def call(:response_error, _opts, _handle_request_error, handle_response_error) do
    handle_response_error.(response_error())
  end

  def call(_conn, _opts, handle_request_error, handle_response_error) do
    handle_request_error.(request_error())
    handle_response_error.(response_error())
  end

  defp request_error,
    do: %Request.ErrorDescription{
      method: "get",
      path: "/fake/path",
      body: %{"foo" => "bar"},
      error: [{"Type mismatch. Expected Number but got String.", "#/msisdn"}]
    }

  defp response_error,
    do: %Response.ErrorDescription{
      request: %{
        method: "get",
        path: "/fake/path"
      },
      status: 200,
      body: ["{", "foo", ":", "bar", "}"],
      error: "invalid"
    }
end
