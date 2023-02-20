defmodule Traefik.Handler do
  @request """
  GET /greetings HTTP/1.1
  Accept: */*
  Connection: keep-alive
  User-Agent: HTTPie/3.2.1
  """

  def handle do
    @request
    |> parse()
    |> route()
    |> format_response()
  end

  def parse(request) do
    [method, path, _protocol] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, response: ""}
  end

  def route(conn) do
    %{conn | response: "Traefik App!"}
  end

  def route(conn, "GET", "/greetings") do
    %{conn | response: "Hello World!"}
  end

  def route(conn, "GET", "/status") do
    %{conn | response: "Up!"}
  end

  def format_response(conn) do
    @request <> "Content-Length: #{String.length(conn.response)}"
  end
end
