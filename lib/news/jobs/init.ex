defmodule News.Jobs.Init do
  alias News.Jobs.Fetcher
  @moduledoc false
  def all_categories do
    {:ok, conn} = Mongo.start_link(url: "mongodb://localhost:27017/news")
    ensure_uniq(conn)
    cursor = Mongo.find(conn, "site", %{})
    c = cursor |> Enum.to_list()
    [categories_queries] = c
    Enum.map categories_queries["categories"], fn(c) ->
      Supervisor.child_spec({Fetcher, c}, id: String.to_atom(c))
    end
  end
  defp ensure_uniq(conn) do
    query = %{
      createIndexes: "articles",
      indexes: [
        %{
          key: [{"title", 1}],
          name: "titleUniq",
          unique: true
        }
      ]
    }
    Mongo.command(conn, query)
  end
end

