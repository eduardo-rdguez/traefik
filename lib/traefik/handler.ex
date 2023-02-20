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
    |> info()
    |> route()
    |> format_response()
  end

  def parse(request) do
    [method, path, _protocol] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, response: "", status: ""}
  end

  def route(conn) do
    %{conn | response: "Traefik App!"}
  end

  def route(conn, "GET", "/greetings") do
    %{conn | response: "Hello World!", status: 200}
  end

  def route(conn, "GET", "/status") do
    %{conn | response: "Up!", status: 200}
  end

  def route(conn, _method, path) do
    %{conn | response: "No #{path} found", status: 404}
  end

  def format_response(conn) do
    """
    HTTP/1.1 #{conn.status} #{status_reason(conn.status)}
    Host: some.com
    User-Agent: telnet
    Content-Length: #{String.length(conn.response)}
    """
  end

  def status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }
    |> Map.get(code)
  end

  def info(conn), do: IO.inspect(conn, label: "Log")
end
