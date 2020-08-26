defmodule News.Util.UtilsTime do
  @moduledoc false

  def input_search_time do
    milliseconds = :os.system_time(:millisecond) + 86400000/2
    date_base   = :calendar.datetime_to_gregorian_seconds({{1970,1,1},{0,0,0}})
    seconds  = trunc(date_base + (milliseconds / 1000))
    {date,_} = :calendar.gregorian_seconds_to_datetime(seconds)
    {y, m, d}  = date
    "#{y}-#{m}-#{d}"
  end

end
