# Repository Guidelines

## Project Structure & Modules

- `src/`: Core library modules.
- `tests/`: Unit tests using Nim's `unittest` plus a `config.nims` that adds
  `src/` to the import path.
- Root files: `chroniclers.nimble` (package manifest), `README.md` (usage),
  `CHANGES.md` (history).

## Build, Test, and Development

- Install deps (Atlas workspace): `atlas install --feature:chronicles`.
- Never use Nimble for dependency setup. Use Atlas and its generated `deps/`
  folder and `nim.cfg` paths.
- Run all tests: `nim test`.
- Run a single test locally: `nim r tests/tchroniclers.nim`.

## Coding Style & Naming

- Indentation: 2 spaces; no tabs.
- Nim style: Types in `PascalCase`, procs/vars in `camelCase`, modules in
  `lowercase` or concise `lowerCamel`.
- Formatting: run `nph src/*.nim tests/*.nim` after edits.

## Testing Guidelines

- Framework: `unittest` with descriptive `suite` and `test` names.
- `nim test` should cover the `chronicles`, `std`, and `none` backends.

## Commit & Pull Requests

- Commits: short, imperative mood.
- PRs: include a clear description, summary of changes, backend implications,
  and test coverage notes.
- Requirements: CI (`nim test`) must pass; include tests for new behavior and
  update `README.md`/`CHANGES.md` as needed.
