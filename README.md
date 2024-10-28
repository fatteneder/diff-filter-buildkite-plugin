# Diff Filter Buildkite Plugin

Filter build steps based on file diffs.

## Example

Add the following to your `pipeline.yml`:

```yml
steps:
  - plugins:
      - https://github.com/fatteneder/diff-filter-buildkite-plugin#main:
        name: docs
        match:
          - "docs/*"
      - https://github.com/fatteneder/diff-filter-buildkite-plugin#main:
        name: build
        match:
          - "*"
        ignore:
          - "**/*.md"
    commands: |
      if [[ $${BUILDKITE_PLUGIN_DIFF_FILTER_TRIGGERED_DOCS} == 1 ]]; then
        # upload docs step
      fi
      if [[ $${BUILDKITE_PLUGIN_DIFF_FILTER_TRIGGERED_BUILD} == 1 ]]; then
        # upload build step
      fi
```


## Development

```bash
docker-compose run --rm lint
docker-compose run --rm tests
```
