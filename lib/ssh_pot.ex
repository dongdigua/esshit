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
  end

  def shell(_username) do
    spawn(fn ->
      SSHPot.FakeCli.cli(5, [])
      IO.puts(IO.ANSI.red() <> "You Muffin Head!" <> IO.ANSI.reset())
    end)
  end

  #def ip({{a, b, c, d}, port}), do: "#{a}.#{b}.#{c}.#{d}:#{port}"

  def log_passwd(user, passwd, _peer, _) do
    Logger.info("#{user},#{passwd}")
    true
  end
end
