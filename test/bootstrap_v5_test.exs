defmodule Scrivener.Components.BootstrapV5Test do
  use ExUnit.Case
  import Phoenix.LiveViewTest
  import Phoenix.Component

  alias Scrivener.Page

  alias Scrivener.Components.BootstrapV5

  test "pagination" do
    page = %Page{
      entries: [],
      page_number: 1,
      page_size: 10,
      total_entries: 0,
      total_pages: 0
    }

    assigns = %{page: page}

    rendered_component =
      rendered_to_string(~H"""
      <BootstrapV5.pagination
        page={@page}
        path={&example_path/1} />
      """)

    assert rendered_component =~ "<nav aria-label=\"Pagination navigation\">"
    assert rendered_component =~ "<ul class=\"pagination\">"
    assert rendered_component =~ "page-item"
    assert rendered_component =~ "page-link"
  end

  test "pagination with ellipsis" do
    page = %Page{
      entries: [Enum.to_list(0..19)],
      page_number: 2,
      page_size: 2,
      total_entries: 20,
      total_pages: 10
    }

    assigns = %{page: page}

    rendered_component =
      rendered_to_string(~H"""
      <BootstrapV5.pagination
        page={@page}
        url_params={[{"q", "term"}]}
        path={&example_path/1} />
      """)

    assert rendered_component =~ "href=\"/posts?q=term&amp;page=3\""
    assert rendered_component =~ "&hellip;"
  end

  test "Custom text options" do
    page = %Page{
      entries: [Enum.to_list(0..39)],
      page_number: 10,
      page_size: 2,
      total_entries: 40,
      total_pages: 20
    }

    options = [
      next: "Suivant",
      previous: "Précédent",
      first: "Premier",
      last: "Dernier"
    ]

    assigns = %{page: page, options: options}

    rendered_component =
      rendered_to_string(~H"""
      <BootstrapV5.pagination
        page={@page}
        url_params={[{"q", "term"}]}
        path={&example_path/1}
        options={@options} />
      """)

    assert rendered_component =~ "Suivant"
    assert rendered_component =~ "Précédent"
    assert rendered_component =~ "Premier"
    assert rendered_component =~ "Dernier"
  end

  defp example_path(nil), do: "/posts"
  defp example_path([]), do: "/posts"

  defp example_path(url_params) do
    "/posts?#{URI.encode_query(url_params)}"
  end
end
