defmodule News.SourceWriters.NewsOrg do
  alias News.Record
  alias News.Util.UtilsTime

  def resolve(search_query) do
    #TODO refine searches and customize it from config
    #url = Application.fetch_env!(:news, :test_url) ## News Org
    {:ok, response_body} = Tesla.get(build_url(search_query))
    #response_body  = Poison.decode!(Application.fetch_env!(:news, :test_res))
    news_articles = Poison.decode!(response_body.body)
    Enum.map build_records(news_articles["articles"]), fn(a) ->
      {result, _} = Mongo.insert_one(:mongo, "articles", a)
      IO.inspect(result)
    end
  end

  defp build_records(results) do
    del_records = Enum.map results, fn(article) ->
      if(article["title"] != nil and article["urlToImage"] != nil) do
        %Record{
          title: article["title"],
          url: article["url"],
          author: article["author"] || article["source"]["name"],
          slug: set_slug(article["title"]),
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

  defp set_slug(a) do
    String.replace(a, ~r/[^a-zA-Z]/, " ") |>
      String.downcase |>
      String.replace(~r/ +/, "-")
  end

  defp build_url(q) do
     url_base = Application.fetch_env!(:news, :url_api)
     query = q
     from = UtilsTime.input_search_time()
     p = Application.fetch_env!(:news, :default_params)
     api_key = "&apiKey=#{p["apiKey"]}"
     default_params = "&sortBy=#{p["sortBy"]}&language=#{p["language"]}&pageSize=#{p["pageSize"]}"
     base = "#{url_base}q=#{query}&from#{from}"
     "#{base}#{default_params}#{api_key}"
  end
end
