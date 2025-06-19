defmodule SSHPot.Db do
  require Logger

  def init_table do
    # must first create a schema on disc using iex --erl '"-mnesia dir <DIR>"'
    :mnesia.create_table(:pot, [attributes: [:timestamp, :user, :passwd, :commands],
                                disc_copies: [node()],
                                type: :ordered_set])
  end

  def add(user, passwd, commands) do
    trans = fn -> :mnesia.write({
      :pot,
      System.os_time(),
      user,
      passwd,
      commands
    }) end
    :mnesia.transaction(trans) |> inspect() |> Logger.info
  end
end
