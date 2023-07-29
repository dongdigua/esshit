defmodule SSHPot.FakeCli do
  @command_io_map %{
    "cat" => " /\\_/\\\n( o.o )\n > ^ <",
    "whoami" => "root",
    "pwd" => "/Never/Gonna/Give/You/Up"
  }

  def cli(0, acc), do: acc

  def cli(count, acc) do
    case IO.gets("[root@rhel]# ") do
      {:error, :interrupted} ->
        IO.puts("^C")
        cli(count - 1, acc)

      input_raw ->
        input = input_raw |> to_string() |> String.trim()
        command = List.first(String.split(input))

        case command do
          "exit" -> acc
          "quit" -> acc
          _ ->
            IO.puts(@command_io_map[command])
            cli(count - 1, acc ++ [input])
        end
    end
  end
end
