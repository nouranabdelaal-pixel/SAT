# sat-demo: a dummy repo for trying Pre-LLM Checks

Needs only Python and Node (no `npm install`, no `pip install`).
Every folder is a small project made to hit one edge case.

| Folder | Edge case | Build | Lint | Tests | Coverage |
|---|---|---|---|---|---|
| broken-service | build fails, so the other stages are skipped (build gate) | FAIL | SKIP | SKIP | SKIP |
| failing-tests | a test fails; its message holds a fake password, masked as `password=***` | SKIP | PASS | FAIL | SKIP |
| needs-deps | package.json needs `left-pad` but there is no node_modules | SKIP | SKIP | SKIP | SKIP |
| shop-api | no linter at all | SKIP | WARN | PASS | SKIP |
| slow-tests | a test takes 2 minutes (TIMEOUT with `--timeout-tests 20s`) | SKIP | WARN | TIMEOUT | SKIP |
| tool-missing | linter set up but not installed | SKIP | WARN | PASS | SKIP |
| web | lint fails; build and tests pass; a fake `API_KEY` is masked; risky scripts skipped; `test` and `test:ci` are the same command, so it runs once | PASS | FAIL | PASS | WARN |

Python projects show Build SKIP because Python has no build step (nothing to run).

Also in this repo:
- `scripts/cleanup.rb`: a Ruby file with no Gemfile gives the `no_project` warning.
- `scripts/plot.R`: R is not supported, so it gives the `unsupported_extension` warning.
- `legacy/`: listed in `ignore` in pre-llm.toml, so its broken app is never scanned.
- `build/`: a skip folder, so the pyproject.toml inside is never scanned.
- No `.gitignore`, so you get the `gitignore_missing` warning.

The web project's coverage shows WARN "no coverage data". Node's built-in coverage report is not read by the tool yet (it is a known gap, not a demo mistake).
