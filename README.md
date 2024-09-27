# ScrivenerComponents

![CI](https://github.com/Tricote/scrivener_components/workflows/CI/badge.svg)

<!-- MDOC !-->

Pagination `Phoenix.Component` for the `Scrivener` library, compatible with Phoenix 1.7 and LiveViews.

_This library is an alternative to [`scrivener_html`](https://github.com/mgwidmann/scrivener_html), which is no longer actively maintained and is not compatible with Phoenix 1.7 and live views (numerous forks have sprung up to correct this by including a dependency on `phoenix_html_helpers`...). It reuses part of the `scrivener_html` code, but it relies on `Phoenix.Component` to generate the pagination HTML code._

## Setup

Add `:scrivener_components` to your project's dependencies:

```elixir
def deps do
  [
    {:scrivener_components, "~> 0.1.0"}
  ]
end
```

Depending on the CSS framework you use, import the component in your view.

```elixir
defp html_helpers do
  quote do
    # ...
    # Import the pagination component for your CSS framework
    import Scrivener.Components.BootstrapV5
  end
end
```

Available framworks / modules:

* Bootstrap V5: `Scrivener.Components.BootstrapV5`
* That's all for now...

## Usage

Use in your template:

```elixir
<.pagination page={page} url_params={[{"q", "term"}]} path={&~p"/index?#{&1}"} />
```

You may customize and translate texts:

```elixir
<.pagination
  page={page}
  url_params={[{"q", "term"}]}
  path={&~p"/posts?#{&1}"}
  navigation_mode={:patch}
  options={[
    next: gettext("Next"),
    previous: gettext("Previous")
  ]} />
  data-custom-attr="hello"
```

Where:

* `page` is a `%Scrivener.Page{}` struct returned from `Repo.paginate/2`
* `url_params` is a list of tuples for the query parameters that will persist accross pagination (typically the current search, filter and/or sort parameters)
* `path` is a 1-arity function that receive the `url_params` merged with the current page number (`page`) and return the path. Typically a verified route sigil like `&~p"/index?#{&1}"`
* `navigation_mode` is an `Atom`, to control the link component navigation mode, can be `:navigate`, `:patch` or `:href` (default: `:navigate`)
* `options` is a `Keyword` list that can be used to customize the behaviour of the pagination:
  - `previous`: the text displayed for the previous link (default: `<<`)
  - `next`: the text displayed for the previous link (default: `>>`)
  - `first`:
    - if `true` (default), display always display the first page link,
    - if a `:string`, replace the page number (1) with the text (ex: `First`)
    - if `false`, the first page is not displayed (if it is not in the distance from the current page...)
  - `last`:
    - if `true` (default), display always display the last page link,
    - if a `:string`, replace the last page number with the text (ex: `Last`)
    - if `false`, the last page is not displayed (if it is not in the distance from the current page...)
  - `ellipsis`: the text to display when number of page is more than the distance, (default: `raw("&hellip;")`)
  - `distance`: the maximum number of page links around the current page to display in the pagination (default: `5`)
* You may add additionals attributes to the pagination component (for JS integration for instance)