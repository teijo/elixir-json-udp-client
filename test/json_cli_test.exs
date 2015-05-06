defmodule JsonCliTest do
  use ExUnit.Case

  test "sent data is echoed back" do
    spawn fn -> JsonCli.listen() end
    server = Socket.UDP.open!(7331)
    server |> Socket.Datagram.send! "foobar", { {127, 0, 0, 1}, 1337 }
    { data, _ } = server |> Socket.Datagram.recv!
    assert data == "foobar"
  end
end
