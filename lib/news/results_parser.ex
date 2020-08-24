defmodule News.ResultsParser do
  def resolve do
    url = Application.fetch_env!(:news, :test_url)
    # {:ok, response} = Tesla.get(url)
    IO.puts("Logging")
  end
end