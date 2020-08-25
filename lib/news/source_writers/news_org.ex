defmodule News.SourceWriters.NewsOrg do
  alias News.Record

  def resolve do
    #TODO refine searches and customize it from config
    #url = Application.fetch_env!(:news, :test_url) ## News Org
    #{:ok, response_body} = Tesla.get(url)
    #response_body  = Poison.decode!(Application.fetch_env!(:news, :test_res))
    #news_articles = Poison.decode!(response_body.body)
    #write_records(news_articles["articles"])
  end

  defp write_records(results) do
    del_records = Enum.map results, fn(article) ->
      if(article["title"] != nil and article["urlToImage"] != nil) do
        %Record{
          title: article["title"],
          url: article["url"],
          author: article["author"] || article["source"]["name"],
          slug: String.replace(article["title"], ~r/[^a-zA-Z]/, "-"),
          source: article["source"]["name"],
          image: article["urlToImage"],
          content: article["content"],
          description: article["description"],
          publishedAt: get_published_at(article),
        }
      end
    end
    Enum.filter(del_records, fn x -> x != nil end)
  end

  defp get_published_at(a) do
    {_, published_at, _} = DateTime.from_iso8601(a["publishedAt"])
    published_at
  end

end
