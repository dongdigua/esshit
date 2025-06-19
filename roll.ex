defmodule RickRoll do
  require Logger
  @frame_time 40
  @frame_height 32
  @rick "./astley80.full"
  @port 2233

  def accept() do
    # don't use :binary
    {:ok, socket} =
      :gen_tcp.listen(@port, [:inet6, packet: 0, active: false, reuseaddr: true])
    {:ok, _} =
      Agent.start_link(fn -> %{} end, name: :kvs)
    Logger.info("Listening on #{@port}")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    # 为了识别用户，得套一层 gen_tcp
    :ssh.daemon(client, [
          system_dir: ~c"./ssh",
          id_string: ~c"SSH-2.0-OpenSSH_RickRoll",
          max_sessions: 1,
          shell: &roll(&1, client),
          auth_methods: ~c"publickey,password",
          # password is none
          pwdfun: fn _,_ -> true end,
          # log every key (note the module name is not aliased)
          key_cb: {RickRoll.KeyCb, [client: client]},
        ])
    Logger.info("Got victim #{inspect(client)}")
    loop_acceptor(socket)
  end

  defmodule KeyCb do
    @behaviour :ssh_server_key_api

    def host_key(algorithm, options) do
      # fallback
      :ssh_file.host_key(algorithm, options)
    end

    def is_auth_key(pk, user, options) do
      client = options[:key_cb_private][:client]
      encoded = :ssh_file.encode([{pk, [comment: user]}], :openssh_key) |> String.trim
      Logger.info(encoded)
      Agent.update(:kvs, fn x ->
        Map.update(x, client, [encoded], fn l -> [encoded|l] end)
      end)
      false
    end
  end

  def roll(_user, client) do
    spawn(fn ->
      parent = self()
      spawn(fn ->
        case IO.gets("") do
          {:error, :interrupted} ->
            IO.puts IO.ANSI.reset
            IO.puts "Your pubkeys:"
            Agent.get(:kvs, fn x -> Map.get(x, client) end) |> Enum.each(&IO.puts(&1))
            IO.puts "#{IO.ANSI.red}Identity noted. Expect a visit soon!"
            IO.puts IO.ANSI.reset
            Process.exit(parent, "")
        end
      end)
      IO.write "#{IO.ANSI.cyan}Authenticating"
      for _ <- 1..3 do
        Process.sleep(300)
        IO.write "."
        Process.sleep(100)
      end
      IO.puts ""
      IO.puts "#{IO.ANSI.green}Access Granted!"
      Process.sleep(500)
      IO.puts "#{IO.ANSI.light_red}SENDING SUPER SECRET DATA..."
      Process.sleep(700)

      File.stream!(@rick, read_ahead: 16384 * 4)
      |> Stream.chunk_every(@frame_height)
      |> Stream.each(fn frame ->
        frame
        |> Enum.join # roughly 16384 in size
        |> IO.write
        Process.sleep(@frame_time)
      end)
      |> Stream.run()
    end)
  end
end

Logger.configure(level: :info)
:ok = :ssh.start()
IO.inspect :erlang.memory
RickRoll.accept()
