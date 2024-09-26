# ScrivenerComponents

<!-- MDOC !-->

Pagination `Phoenix.Component` for the `Scrivener` library.

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
```

Where:

* `page` is a `%Scrivener.Page{}` struct returned from `Repo.paginate/2`
* `url_params` is a list of tuples for the query parameters that will persist accross pagination (typically the current search, filter and/or sort parameters)
* `path` is a 1-arity function that receive the `url_params` merged with the current page number (`page`) and return the path. Typically a verified route sigil like `&~p"/index?#{&1}"`
* `navigation_mode` is an `Atom`, to control the link component navigation mode, can be `:navigate`, `:patch` or `:href` (default: `:navigate`)
* `options` is a `Keyword` list that can be used to customize the behaviour of the pagination:
  - `previous`: the text displayed for the previous link (default: `<<`)
  - `next`: the text displayed for the previous link (default: `>>`)
  - `first`: the text displayed for the first page link (default: `>>`)
  - `last`: the text displayed for the last page link (default: `<<`)
  - `ellipsis`: the text to display when number of page is more than the distance, (default: `raw("&hellip;")`)
  - `distance`: the maximum number of page links around the current page to display in the pagination (default: `5`)

## TODO

- [ ] Implement other CSS framework pagination component (foundation, maetrialize,... )