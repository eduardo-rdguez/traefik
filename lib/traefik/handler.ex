defmodule Traefik.Handler do
  @request """
    GET / HTTP/1.1
    Accept: */*
    Connection: keep-alive
    User-Agent: HTTPie/3.2.1
  """

  def handle do
    @request
    |> parse()
  end

  def parse(request) do
    [method, path, _protocol] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, response: ""}
  end
end
