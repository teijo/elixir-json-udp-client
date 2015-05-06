defmodule JsonCli do
  defp read(server) do
    { data, client } = server |> Socket.Datagram.recv!
    server |> Socket.Datagram.send! data, client
    read(server)
  end

  def listen() do
    server = Socket.UDP.open!(1337)
    read(server)
  end
end
