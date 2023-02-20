defmodule Traefik.Handler do
  @request """
  GET /about HTTP/1.1
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

  def route(%{method: "GET", path: "/greetings"} = conn) do
    %{conn | response: "Hello World!", status: 200}
  end

  def route(%{method: "GET", path: "/about"} = conn) do
    Path.expand("../../pages", __DIR__)
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conn)
  end

  def route(%{path: path} = conn) do
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

  def handle_file({:ok, content}, conn), do: %{conn | response: content, status: 200}

  def handle_file({:error, reason}, conn),
    do: %{conn | response: "File not found: #{reason}", status: 404}

  def info(conn), do: IO.inspect(conn, label: "Log")
end
