defmodule JsonCliTest do
  use ExUnit.Case

  test "init and ping" do
    host = {127, 0, 0, 1}
    server_port_1 = 7331
    server_port_2 = 7332
    client_port = 1337
    connection_id = "foobar"

    msg_ping = ~s({"type": "ping"})
    msg_connect_ok = ~s({"type": "connect-ok", "connection-id": "#{connection_id}", "address": "127.0.0.1", "port": #{server_port_2}})

    socket_1 = Socket.UDP.open! server_port_1
    socket_2 = Socket.UDP.open! server_port_2

    spawn fn -> JsonCli.start(host, client_port, host, server_port_1) end

    { reply_connect, _ } = socket_1 |> Socket.Datagram.recv!
    assert reply_connect == ~s({"type": "connect", "address": "#{JsonCli.ip_string(host)}", "port": #{client_port}})

    socket_1 |> Socket.Datagram.send! msg_connect_ok, {host, client_port}
    socket_2 |> Socket.Datagram.send! msg_ping, {host, client_port}

    { data, _ } = socket_2 |> Socket.Datagram.recv!
    assert data == ~s({"type": "pong", "connection-id": "#{connection_id}"})
  end
end
