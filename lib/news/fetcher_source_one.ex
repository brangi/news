defmodule News.FetcherSourceOne do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  @impl true
  def init(state) do
    schedule_fetcher_one()
    {:ok, state}
  end

  @impl true
  def handle_info(:work, state) do
    IO.puts("Fetching....")
    schedule_fetcher_one()

    {:noreply, state}
  end

  defp schedule_fetcher_one do
    Process.send_after(self(), :work, 1 * 60 * 60 * 1000)
  end
end