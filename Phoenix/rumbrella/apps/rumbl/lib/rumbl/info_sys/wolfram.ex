defmodule InfoSys.Wolfram do
  import SweetXml
  alias InfoSys.Result

  def start_link(query, ref, owner, limit) do
    Task.start_link(__MODULE__, :fetch, [query, ref, owner, limit])
  end

  def fetch(query, ref, owner, _limit) do
    query |> fetch_xml()
          |> xpath(~x"/queryresult/pod[contains(@title, 'Result') or
                    contains(@title, 'Definitions')]/subpod/plaintext/text()")
          |> send_results(ref, owner)
  end

  defp fetch_xml(query) do
    {:ok, {_,_, body}} = String.to_char_list( #OR, String.to_charlist
      "http://api.wolframalpha.com/v2/query" <>
                        "?appid=#{app_id()}" <>
      "&input=#{URI.encode(query)}&format=plaintext"
    ) |> :httpc.request

    body
  end

  defp app_id, do: Application.get_env(:rumbl, :wolfram)[:app_id]

  defp send_results(nil, ref, owner), do: send(owner, {:results, ref, []})
  defp send_results(answer, ref, owner) do
    results = [%Result{backend: "wolfram", score: 95, text: to_string(answer)}]
    send(owner, {:results, ref, results})
  end
end
