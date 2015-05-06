Setup
-----

From http://elixir-lang.org/install.html

### Ubuntu 12.04 and 14.04 / Debian 7

 - Add Erlang Solutions repo: `wget http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb`
 - `sudo apt-get update`
 - `sudo apt-get install elixir`

Test installation
-----------------

 - `elixir -v` should print the Elixir version
 - `iex` starts REPL

Build
-----

Download dependencies defined in `mix.exs`, asks to install Hex on first run.

`mix deps.get`

Run test
--------

Run tests found under `test/`.

`mix test`

Run program
-----------

`mix run -e JsonCli.listen`

Helpers
-------

Send UDP messages from command line using Netcat

`echo -n "foobar" | nc -u -w0 127.0.0.1 1337`
