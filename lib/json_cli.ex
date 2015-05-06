defmodule ConnectOkMessage do
  defstruct [:type, :"connection-id", :address, :port]
end

defmodule PingMessage do
  defstruct [:type]
end

defmodule Server do
  defstruct [:id, :address, :port]
end

defmodule JsonCli do
  defp init_sequence(socket) do
    { data, _ } = socket |> Socket.Datagram.recv!
    message = Poison.decode!(data, as: ConnectOkMessage)
    case message do
      %ConnectOkMessage{type: "connect-ok", "connection-id": connection_id, address: address, port: port} ->
        # IO.puts("connect-ok: #{connection_id}, address: #{address}, port: #{port}")
        %Server{id: connection_id, address: address, port: port}
      _ ->
        IO.puts "GOT UNEXPECTED MESSAGE"
        IO.inspect message
        {}
    end
  end

  defp listen(socket, server) do
    { data, client } = socket |> Socket.Datagram.recv!
    message = Poison.decode!(data, as: PingMessage)
    case message do
      %PingMessage{type: "ping"} ->
        socket |> Socket.Datagram.send!(~s({"type": "pong", "connection-id": "#{server.id}"}), client)
      _ ->
        IO.puts "GOT UNEXPECTED MESSAGE"
        IO.inspect message
    end
    listen(socket, server)
  end

  def ip_string(ip_tuple) do
    Enum.join(Tuple.to_list(ip_tuple), ".")
  end

  def start(client_host, client_port, server_host, server_port) do
    socket = Socket.UDP.open!(client_port)
    socket |> Socket.Datagram.send! ~s({"type": "connect", "address": "#{ip_string(client_host)}", "port": #{client_port}}), {server_host, server_port}
    server = init_sequence(socket)
    listen(socket, server)
  end
end
