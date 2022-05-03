defmodule SSHPot.FakeCli do
  def cli(0, acc), do: acc
  def cli(count, acc) do
    input_raw = IO.gets("[root@rhel]# ")
    input = input_raw |> to_string() |> String.trim()
    cond do
      input =~ ~r/cat/ -> cat()
      input =~ ~r/whoami/ -> IO.puts("root")
      true -> IO.puts(IO.ANSI.red() <> "\u262d" <> IO.ANSI.reset())
    end
    cli(count - 1, acc ++ [input_raw])
  end

  def cat() do
    IO.puts("""
     /\\_/\\
    ( o.o )
     > ^ <
    """)
  end

end
