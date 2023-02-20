defmodule Traefik.Plugs do
  def info(conn), do: IO.inspect(conn, label: "Log")
end
