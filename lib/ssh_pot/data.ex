defmodule SSHPot.Data do

  def data_loop(:'$end_of_table', _fun, acc), do: acc

  def data_loop(cur_key, fun, acc) do
    [{:pot, _time, user, pwd, _commands}] = :mnesia.dirty_read(:pot, cur_key)
    data_loop(:mnesia.dirty_next(:pot, cur_key), fun, fun.([usr: user, pwd: pwd], acc))
  end

  def sort(idx) do
      fun = fn usr_pwd, acc ->
        Map.update(acc, usr_pwd[idx], 1, &(&1 + 1))
      end
      res = data_loop(:mnesia.dirty_first(:pot), fun, %{})
      Enum.sort(Map.keys(res), &(res[&1] >= res[&2]))
      |> Enum.map(fn x -> {x, res[x]} end)
  end

  def find(idx, regex) do
    fun = fn usr_pwd, acc ->
      if String.match?(usr_pwd[idx], regex) do
        [usr_pwd | acc]
      else
        acc
      end
    end
    data_loop(:mnesia.dirty_first(:pot), fun, [])
  end
end
