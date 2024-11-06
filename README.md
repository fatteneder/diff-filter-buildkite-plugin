# Diff Filter Buildkite Plugin

Filter build steps based on file diffs.

## Example

Add the following to your `pipeline.yml`:

```yml
steps:
  - plugins:
      - fatteneder/diff-filter#v1.0.0:
        name: TRIGGER_DOCS
        match:
          - "docs/*"
      - fatteneder/diff-filter#v1.0.0:
        name: TRIGGER_BUILD
        match:
          - "*"
        ignore:
          - "**/*.md"
    commands: |
      if [[ $${TRIGGER_DOCS} == 1 ]]; then
        # upload docs step
      fi
      if [[ $${TRIGGER_BUILD} == 1 ]]; then
        # upload build step
      fi
```

## Configuration

- `name`: The name of the exported environment variable.
- `match`: A list of glob patterns. If a filename from the `git diff` matches a pattern in this list,
  then the environment variable `name` is exported with the value `1`, otherwise it is `0`.
- `ignore`: A list of glob patterns. Filenames that match a pattern in this list are ignored
  in the `git diff`.


## Development

```bash
docker-compose run --rm lint
docker-compose run --rm tests
```
