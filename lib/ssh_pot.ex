defmodule SSHPot do
  require Logger
  @sys_dir String.to_charlist(Path.expand(".") <> "/ssh")
  @username 'root'
  @passwd 'toor'
  @port 2222

  def start_link do
    :ssh.daemon(@port, [
      system_dir: @sys_dir,
      id_string: 'OpenSSH 8.4 redhat',
      shell: &shell/2,
      pwdfun: &log_it/4
    ])
  end

  def shell(_username, peer) do
    spawn(fn ->
      Logger.warning(IO.ANSI.green() <> "cracked!" <> IO.ANSI.reset())
      Logger.warning("ip: #{ip(peer)}, time: #{inspect(:erlang.time())}, user_input: #{inspect(IO.gets("root@rhel# "))}")
      IO.puts(IO.ANSI.red() <> "Oh Shit! You Muffin Head!" <> IO.ANSI.reset()) end)
  end

  def ip({{a, b, c, d}, port}), do: "#{a}.#{b}.#{c}.#{d}:#{port}"

  def log_it(user, passwd, peer, _) do
    if user == @username and passwd == @passwd do
      true
    else
      Logger.warning("#{ip(peer)} tried #{inspect(passwd)}")
      false
    end
  end
end
