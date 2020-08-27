defmodule News.Jobs.Fetcher do
  use GenServer
  alias News.SourceWriters.NewsOrg

  def start_link(s) do
    GenServer.start_link(__MODULE__, %{search_query: s})
  end

  @impl true
  def init(state) do
    schedule_agg()
    {:ok, state}
  end

  @impl true
  def handle_info(:work, state) do
    IO.puts("Fetching")
    IO.inspect(state)
    NewsOrg.resolve(state["search_query"])
    schedule_agg()
    {:noreply, state}
  end

  defp schedule_agg do
    Process.send_after(self(), :work, 1 * 60 * 60 * 1000)
  end
end