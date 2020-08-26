defmodule News.Jobs.Init do
  @moduledoc false
  def all_categories do
    {:ok, conn} = Mongo.start_link(url: "mongodb://localhost:27017/news")
    cursor = Mongo.find(conn, "site", %{})
    c = cursor |> Enum.to_list()
    [categories_queries] = c
    Enum.map categories_queries["categories"], fn(c) ->
      Supervisor.child_spec({News.Jobs.Fetcher, c}, id: String.to_atom(c))
    end
  end
end

