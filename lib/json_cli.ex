defmodule Body do
  defstruct [:boolean, :string, :number]
end

defmodule Message do
  defstruct [:type, body: Body]
end

defmodule JsonCli do
  defp read(server) do
    { data, client } = server |> Socket.Datagram.recv!
    message = Poison.decode!(data, as: Message)
    case message do
      %Message{type: "test", body: body} -> server |> Socket.Datagram.send!(~s([#{body["boolean"]}, "#{body["string"]}", #{body["number"]}]), client)
      _ -> server |> Socket.Datagram.send!("got unexpected message", client)
    end
    read(server)
  end

  def listen() do
    server = Socket.UDP.open!(1337)
    read(server)
  end
end
