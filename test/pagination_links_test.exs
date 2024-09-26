defmodule Scrivener.Components.PaginationLinksTest do
  use ExUnit.Case

  alias Scrivener.Components.PaginationLinks

  describe "raw_pagination_links for a page" do
    test "in the middle" do
      assert pages(45..55) == links_with_opts(total_pages: 100, page_number: 50)
    end

    test ":distance from the first" do
      assert pages(1..10) == links_with_opts(total_pages: 20, page_number: 5)
    end

    test "2 away from the first" do
      assert pages(1..8) == links_with_opts(total_pages: 10, page_number: 3)
    end

    test "1 away from the first" do
      assert pages(1..7) == links_with_opts(total_pages: 10, page_number: 2)
    end

    test "at the first" do
      assert pages(1..6) == links_with_opts(total_pages: 10, page_number: 1)
    end

    test ":distance from the last" do
      assert pages(10..20) == links_with_opts(total_pages: 20, page_number: 15)
    end

    test "2 away from the last" do
      assert pages(3..10) == links_with_opts(total_pages: 10, page_number: 8)
    end

    test "1 away from the last" do
      assert pages(4..10) == links_with_opts(total_pages: 10, page_number: 9)
    end

    test "at the last" do
      assert pages(5..10) == links_with_opts(total_pages: 10, page_number: 10)
    end

    test "page value larger than total pages" do
      assert pages(5..10) == links_with_opts(total_pages: 10, page_number: 100)
    end

    test "with custom IO list as first" do
      assert pages_with_first({["←"], 1}, 5..15) ==
               links_with_opts([total_pages: 20, page_number: 10], first: ["←"])
    end

    test "with custom IO list as last" do
      assert pages_with_last({["→"], 20}, 5..15) ==
               links_with_opts([total_pages: 20, page_number: 10], last: ["→"])
    end
  end

  describe "raw_pagination_links next" do
    test "includes a next" do
      assert pages_with_next(45..55, 51) ==
               links_with_opts([total_pages: 100, page_number: 50], next: ">>")
    end

    test "does not include next when equal to the total" do
      assert pages(5..10) == links_with_opts([total_pages: 10, page_number: 10], next: ">>")
    end

    test "can disable next" do
      assert pages(45..55) == links_with_opts([total_pages: 100, page_number: 50], next: false)
    end
  end

  describe "raw_pagination_links previous" do
    test "includes a previous" do
      assert pages_with_previous(49, 45..55) ==
               links_with_opts([total_pages: 100, page_number: 50], previous: "<<")
    end

    test "includes a previous before the first" do
      assert [{"<<", 49}, {1, 1}, {:ellipsis, Phoenix.HTML.raw("&hellip;")}] ++ pages(45..55) ==
               links_with_opts([total_pages: 100, page_number: 50], previous: "<<", first: true)
    end

    test "does not include previous when equal to page 1" do
      assert pages(1..6) == links_with_opts([total_pages: 10, page_number: 1], previous: "<<")
    end

    test "can disable previous" do
      assert pages(45..55) ==
               links_with_opts([total_pages: 100, page_number: 50], previous: false)
    end
  end

  describe "raw_pagination_links first" do
    test "includes the first" do
      assert pages_with_first(1, 5..15) ==
               links_with_opts([total_pages: 20, page_number: 10], first: true)
    end

    test "does not the include the first when it is already included" do
      assert pages(1..10) == links_with_opts([total_pages: 10, page_number: 5], first: true)
    end

    test "can disable first" do
      assert pages(5..15) == links_with_opts([total_pages: 20, page_number: 10], first: false)
    end
  end

  describe "raw_pagination_links last" do
    test "includes the last" do
      assert pages_with_last(20, 5..15) ==
               links_with_opts([total_pages: 20, page_number: 10], last: true)
    end

    test "does not the include the last when it is already included" do
      assert pages(1..10) == links_with_opts([total_pages: 10, page_number: 5], last: true)
    end

    test "can disable last" do
      assert pages(5..15) == links_with_opts([total_pages: 20, page_number: 10], last: false)
    end
  end

  describe "raw_pagination_links distance" do
    test "can change the distance" do
      assert pages(1..3) == links_with_opts([total_pages: 3, page_number: 2], distance: 1)
    end

    test "does not allow negative distances" do
      assert_raise RuntimeError, "Scrivener.Components: Distance cannot be less than one.", fn ->
        links_with_opts([total_pages: 10, page_number: 5], distance: -5)
      end
    end
  end

  describe "raw_pagination_links ellipsis" do
    test "includes ellipsis after first" do
      assert [{1, 1}, {:ellipsis, "&hellip;"}] ++ pages(45..55) ==
               links_with_opts([total_pages: 100, page_number: 50],
                 previous: false,
                 first: true,
                 ellipsis: "&hellip;"
               )
    end

    test "includes ellipsis before last" do
      assert pages(5..15) ++ [{:ellipsis, "&hellip;"}, {20, 20}] ==
               links_with_opts([total_pages: 20, page_number: 10],
                 last: true,
                 ellipsis: "&hellip;"
               )
    end

    test "does not include ellipsis on first page" do
      assert pages(1..6) ==
               links_with_opts([total_pages: 8, page_number: 1],
                 first: true,
                 ellipsis: "&hellip;"
               )
    end

    test "uses ellipsis only beyond <distance> of first page" do
      assert pages(1..11) ==
               links_with_opts([total_pages: 20, page_number: 6],
                 first: true,
                 ellipsis: "&hellip;"
               )

      assert [{1, 1}] ++ pages(2..12) ==
               links_with_opts([total_pages: 20, page_number: 7],
                 first: true,
                 ellipsis: "&hellip;"
               )
    end

    test "when first/last are true, uses ellipsis only when (<distance> + 1) is greater than the total pages" do
      options = [first: true, last: true, distance: 1]

      assert pages(1..3) == links_with_opts([total_pages: 3, page_number: 1], options)
      assert pages(1..3) == links_with_opts([total_pages: 3, page_number: 3], options)
    end

    test "does not include ellipsis on last page" do
      assert pages(15..20) ==
               links_with_opts([total_pages: 20, page_number: 20],
                 last: true,
                 ellipsis: "&hellip;"
               )
    end

    test "uses ellipsis only beyond <distance> of last page" do
      assert pages(10..20) ==
               links_with_opts([total_pages: 20, page_number: 15],
                 last: true,
                 ellipsis: "&hellip;"
               )

      assert pages(9..19) ++ [{20, 20}] ==
               links_with_opts([total_pages: 20, page_number: 14],
                 last: true,
                 ellipsis: "&hellip;"
               )
    end
  end

  ##############################
  # Test helpers
  ##############################
  defp pages(range), do: Enum.to_list(range) |> Enum.map(&{&1, &1})

  defp pages_with_first({first, num}, range),
    do: [{first, num}, {:ellipsis, Phoenix.HTML.raw("&hellip;")}] ++ pages(range)

  defp pages_with_first(first, range),
    do: [{first, first}, {:ellipsis, Phoenix.HTML.raw("&hellip;")}] ++ pages(range)

  defp pages_with_last({last, num}, range),
    do: pages(range) ++ [{:ellipsis, Phoenix.HTML.raw("&hellip;")}, {last, num}]

  defp pages_with_last(last, range),
    do: pages(range) ++ [{:ellipsis, Phoenix.HTML.raw("&hellip;")}, {last, last}]

  defp pages_with_next(range, next), do: pages(range) ++ [{">>", next}]
  defp pages_with_previous(previous, range), do: [{"<<", previous}] ++ pages(range)

  defp links_with_opts(paginator, opts \\ []) do
    paginator
    |> Enum.into(%{})
    |> PaginationLinks.raw_pagination_links(
      Keyword.merge([next: false, previous: false, first: false, last: false], opts)
    )
  end
end
