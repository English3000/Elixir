defmodule Rumbl.WatchView do
  use Rumbl.Web, :view

  def player_id(video) do
    ~r{^.*(?:youtu\.be/|\w+/|v=)(?<id>[^#&?]*)}
    |> Regex.named_captures(video.url) #extracts id
    |> get_in(["id"]) #maps "id" to extracted value
  end
end
