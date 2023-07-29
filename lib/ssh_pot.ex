defmodule SSHPot do
  require Logger
  @sys_dir String.to_charlist(Path.expand(".") <> "/ssh")
  @port 2222

  def start_link do
    :ssh.daemon(@port, [
      system_dir: @sys_dir,
      id_string: 'OpenSSH_9.0',
      auth_method_kb_interactive_data: {'', '',  'password: ', false},
      shell: &shell/1,
      pwdfun: &log_passwd/4
    ])
    Agent.start_link(fn -> {nil, nil} end, name: __MODULE__)
  end

  def shell(_username) do
    spawn(fn ->
      commands = SSHPot.FakeCli.cli(5, [])
      IO.puts(IO.ANSI.red() <> "You Muffin Head!" <> IO.ANSI.reset())
      {user, passwd} = Agent.get(__MODULE__, & &1)
      SSHPot.Db.add(user, passwd, commands)
    end)
  end

  #def ip({{a, b, c, d}, port}), do: "#{a}.#{b}.#{c}.#{d}:#{port}"

  def log_passwd(user, passwd, _peer, _) do
    user = List.to_string(user)
    passwd = List.to_string(passwd)
    Logger.info("#{user},#{passwd}")
    Agent.update(__MODULE__, fn _ -> {user, passwd} end)
    true
  end
end
