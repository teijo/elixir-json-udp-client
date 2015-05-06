defmodule JsonCli do
  defp read(server) do
    IO.puts("Waiting for data")
    { data, client } = server |> Socket.Datagram.recv!
    IO.puts("Received: #{data}")
    server |> Socket.Datagram.send! data, client
    read(server)
  end

  def listen() do
    server = Socket.UDP.open!(1337)
    read(server)
  end
end
