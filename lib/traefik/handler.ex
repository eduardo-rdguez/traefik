defmodule Traefik.Handler do
  @request """
    GET / HTTP/1.1
    Accept: */*
    Connection: keep-alive
    User-Agent: HTTPie/3.2.1
  """

  def handle do
    @request
  end
end
