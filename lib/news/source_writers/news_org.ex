defmodule News.SourceWriters.NewsOrg do
  alias News.Record
  def resolve do
    #TODO refine searches and customize it from config
    # url = Application.fetch_env!(:news, :test_url) // News Org
    # {:ok, response} = Tesla.get(url)
    response_body  = Poison.decode!(Application.fetch_env!(:news, :test_res))
    news_articles = Map.get(response_body, "articles")
    write_records(news_articles)
  end

  defp write_records(results) do
    Enum.map results, fn(article) ->
      %Record{
        title: article["title"],
        url: article["url"],
        author: article["author"],
        #hibernating: (if article["source"], do: true, else: false)
      }
    end
  end
end
