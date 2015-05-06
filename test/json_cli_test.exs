defmodule JsonCliTest do
  use ExUnit.Case

  spawn fn -> JsonCli.listen() end

  test "sent data is parsed and sent back" do
    server = Socket.UDP.open!(7331)
    server |> Socket.Datagram.send! ~s({"type": "test", "body": {"boolean": true, "string": "foobar", "number": 3}}), { {127, 0, 0, 1}, 1337 }
    { data, _ } = server |> Socket.Datagram.recv!
    assert data == ~s([true, "foobar", 3])
  end

  test "invalid message" do
    server = Socket.UDP.open!(7331)
    server |> Socket.Datagram.send! ~s({}), { {127, 0, 0, 1}, 1337 }
    { data, _ } = server |> Socket.Datagram.recv!
    assert data == "got unexpected message"
  end
end
