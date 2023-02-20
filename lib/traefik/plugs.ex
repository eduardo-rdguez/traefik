defmodule Traefik.Plugs do
  alias Traefik.Conn

  def info(%Conn{} = conn), do: IO.inspect(conn, label: "Log")
end
