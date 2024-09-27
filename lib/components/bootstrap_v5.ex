defmodule Scrivener.Components.BootstrapV5 do
  @moduledoc """
  Bootstrap 5 pagination component for the Scrivener library

  Based on https://getbootstrap.com/docs/5.3/components/pagination/#overview

  Renders the following structure:

      <nav aria-label="Page navigation example">
        <ul class="pagination">
          <li class="page-item"><a class="page-link" href="#">Previous</a></li>
          <li class="page-item"><a class="page-link" href="#">1</a></li>
          <li class="page-item"><a class="page-link" href="#">2</a></li>
          <li class="page-item"><a class="page-link" href="#">3</a></li>
          <li class="page-item"><span class="page-link">…</span></li>
          <li class="page-item"><a class="page-link" href="#">Next</a></li>
        </ul>
      </nav>

  """
  use Phoenix.Component
  alias Scrivener.Components.PaginationLinks

  @doc ~S"""
  Renders a pagination component

  ## Examples

      <.pagination page={@page} url_params={["q", "term"]} path={&~p"/index?#{&1}"} />
  """
  attr(:page, Scrivener.Page,
    required: true,
    doc: "a `%Scrivener.Page{}` struct returned from `Repo.paginate/2`"
  )

  attr(:url_params, :list,
    default: [],
    doc:
      "a list of tuples for the query parameters that will persist accross pagination (typically the current search, filter and/or sort parameters)"
  )

  attr(:page_param, :string, default: "page")

  attr(:path, :any,
    required: true,
    doc:
      "a 1-arity function that receives the `url_params` merged with the current page number (`page`) and return the path. Typically a verified route sigil"
  )

  attr(:navigation_mode, :atom,
    default: :navigate,
    values: [:navigate, :patch, :href],
    doc: "the link component navigation mode"
  )

  attr(:options, :any,
    default: [],
    doc:
      "a `Keyword` list that can be used to customize the behaviour of the pagination. See `Scrivener.Components.PaginationLinks` defaults"
  )

  attr(:rest, :global)

  def pagination(assigns) do
    assigns =
      assigns
      |> assign_new(:entries, fn %{page: page} -> page.entries end)
      |> assign_new(:page_number, fn %{page: page} -> page.page_number end)
      |> assign_new(:page_size, fn %{page: page} -> page.page_size end)
      |> assign_new(:total_entries, fn %{page: page} -> page.total_entries end)
      |> assign_new(:total_pages, fn %{page: page} -> page.total_pages end)

    ~H"""
    <nav aria-label={"Pagination navigation"} {@rest}>
      <ul class="pagination">
        <%= for {text, page_number} <- PaginationLinks.raw_pagination_links(@page, @options) do %>
          <.page
            text={text}
            page_number={page_number}
            url_params={@url_params}
            page={@page}
            path={@path}
            navigation_mode={@navigation_mode}
          />
        <% end %>
      </ul>
    </nav>
    """
  end

  attr(:text, :string)
  attr(:page_number, :integer, required: true)
  attr(:url_params, :map, default: [])
  attr(:page_param, :string, default: "page")
  attr(:page, Scrivener.Page, required: true)
  attr(:path, :any)

  attr(:navigation_mode, :atom,
    required: true,
    values: [:navigate, :patch, :href]
  )

  defp page(%{text: :ellipsis} = assigns) do
    ~H"""
    <li class="page-item">
      <span class="page-link">
        <%= safe(@page_number) %>
      </span>
    </li>
    """
  end

  defp page(assigns) do
    assigns =
      assigns
      |> assign_new(
        :params_with_page,
        fn %{url_params: url_params, page_number: page_number, page_param: page_param} ->
          url_params ++
            case page_number > 1 do
              true -> [{page_param, page_number}]
              false -> []
            end
        end
      )
      |> assign_new(
        :to,
        fn %{params_with_page: params_with_page, path: path} ->
          path.(params_with_page)
        end
      )
      |> assign_new(
        :navigation,
        fn %{params_with_page: params_with_page, path: path} ->
          Map.put(%{}, assigns.navigation_mode, path.(params_with_page))
        end
      )

    ~H"""
    <li class={li_classes(@page, @page_number)}>
      <%= if active_page?(@page, @page_number) do %>
        <span class={link_classes(@page, @page_number)}>
          <%= safe(@text) %>
        </span>
      <% else %>
        <.link
          class={link_classes(@page, @page_number)}
          rel={rel(@page, @page_number)}
          {@navigation}
        >
          <%= safe(@text) %>
        </.link>
      <% end %>
    </li>
    """
  end

  defp li_classes(page, page_number) do
    if(page.page_number == page_number, do: ["active", "page-item"], else: ["page-item"])
  end

  defp link_classes(_page, _page_number), do: ["page-link"]

  defp active_page?(%{page_number: page_number}, page_number), do: true
  defp active_page?(_page, _page_number), do: false

  defp rel(%Scrivener.Page{page_number: current_page}, page_number)
       when current_page + 1 == page_number,
       do: "next"

  defp rel(%Scrivener.Page{page_number: current_page}, page_number)
       when current_page - 1 == page_number,
       do: "prev"

  defp rel(_page, _page_number), do: ""

  defp safe({:safe, _string} = whole_string) do
    whole_string
  end

  defp safe(string) when is_binary(string) do
    string
  end

  defp safe(string) do
    string
    |> to_string()
    |> Phoenix.HTML.raw()
  end
end
