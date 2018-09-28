defmodule URL do
  def write(urls, file),
    do: File.write(file, to_html(urls))

  defp to_html(urls),
    do: [ to_html("h1", "URLs"), to_html("ul", urls) ]

  defp to_html(tag, content) do
    "<#{tag}>#{
      cond do
        is_binary(content) == true -> content
        is_list(content)   == true -> Enum.map(content, &(to_html("li", &1)))
      end
    }</#{tag}>\n"
  end

  def scrape(term, list \\ [])
  def scrape("<a href" <> tail, list) do # ?
    {url, new_tail} = body(tail, String.reverse("<a href"))
    scrape(new_tail, [url | list])
  end
  def scrape([_|tail], list),
    do: scrape(tail, list)
  def scrape([], list),
    do: list

  defp body("</a>" <> tail, list),
    do: {Enum.reverse(list, "</a>"), tail}
  defp body([head | tail], list),
    do: body(tail, [head | list])
  defp body([], _),
    do: {[], []}
  # not working -- other examples: https://andrealeopardi.com/posts/handling-tcp-connections-in-elixir/
  def get(url) do                # https://elixir-lang.org/getting-started/mix-otp/task-and-gen-tcp.html
    {:ok, socket} = :gen_tcp.connect(url, 80, :binary) # [:binary, packet: 0]
    :ok = :gen_tcp.send(socket, "GET / HTTP/1.0\r\n\r\n")
    handle_response(socket, [])
  end

  defp handle_response(socket, data) do
    receive do
      {:tcp, pid, binary} when socket == pid -> handle_response(socket, [binary | data])
      {:tcp_closed, pid}  when socket == pid -> Enum.reverse(data) |> to_string
    end
  end
end
