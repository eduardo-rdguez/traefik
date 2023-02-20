defmodule Traefik.Handler do
  import Traefik.Parser, only: [parse: 1]
  import Traefik.Plugs, only: [info: 1]

  alias Traefik.Conn

  @request """
  GET /about HTTP/1.1
  Accept: */*
  Connection: keep-alive
  User-Agent: HTTPie/3.2.1
  """

  @pages_path Path.expand("../../pages", __DIR__)

  def handle do
    @request
    |> parse()
    |> info()
    |> route()
    |> format_response()
  end

  def route(%Conn{method: "GET", path: "/greetings"} = conn) do
    %{conn | response: "Hello World!", status: 200}
  end

  def route(%Conn{method: "GET", path: "/about"} = conn) do
    @pages_path
    |> Path.join("about.html")
    |> File.read()
    |> handle_file(conn)
  end

  def route(%Conn{method: _method, path: path} = conn) do
    %{conn | response: "No #{path} found", status: 404}
  end

  def format_response(%Conn{} = conn) do
    """
    HTTP/1.1 #{Conn.status(conn)}
    Host: some.com
    User-Agent: telnet
    Content-Length: #{String.length(conn.response)}
    """
  end

  def handle_file({:ok, content}, %Conn{} = conn), do: %{conn | response: content, status: 200}

  def handle_file({:error, reason}, %Conn{} = conn),
    do: %{conn | response: "File not found: #{reason}", status: 404}
end
