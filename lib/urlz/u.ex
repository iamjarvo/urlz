defmodule Urlz.Url do
  defstruct [:destination, :slug]
end

defimpl String.Chars, for: Urlz.Url do
  def to_string(%Urlz.Url{destination: destination, slug: slug} = url) do
    "slug: #{slug} destination: #{destination}"
  end
  def to_string(url) do
    "meh - can't do that"
  end
end
