# Dummy projects for the validation script

Throwaway projects that exercise `validate.sh` / `validate.ps1`: one per Language,
plus failing variants and the layout, precedence and config edge cases. They live
outside the `code-review-agent` repo on purpose.

```sh
./run-all.sh            # run every case, compare exit codes with cases.tsv
./run-all.sh -v ts-     # only names containing "ts-", with per-Gate statuses
VALIDATOR=/path/to/validate.sh ./run-all.sh
```

`cases.tsv` lists each project, the exit code it should give and what it exercises.
An expected exit of `?` means the result depends on which toolchains are installed
(for example `go-module` is SKIPPED without Go and a real run with it), so it is shown
but not asserted.

## Prerequisites on this machine
Every Language runs for real, so every toolchain must be installed. Source `~/toolchains/env.sh`
(`run-all.sh` does it for you); it puts these on `PATH`: Go, Rust (clippy, `cargo-llvm-cov`), Maven,
Gradle, Elixir/Erlang, `golangci-lint`, PHP (`pcov`) with Composer, CMake, `clang-tidy`, sbt, SwiftLint.
Also expected: `node`/`npm`, `python3` plus the repo's `.venv` (pytest, pytest-cov, ruff, flask), the .NET
SDK, Ruby with Bundler, Java 17 and Swift (Xcode). The projects fetch their own dependencies on first run
(Maven Central, NuGet, npm, PyPI, RubyGems, crates.io, Hex, Packagist), so the first run needs network access.
The `ts-*` projects symlink `node_modules` to `code-review-agent/fixtures/js-ts-passing/node_modules`.

## Groups
| Group | Projects |
|---|---|
| TypeScript | `ts-passing`, `ts-test-fails`, `ts-no-tests`, `ts-tests-only-in-node_modules`, `ts-no-eslint-config`, `ts-lint-fails`, `ts-build-fails`, `ts-no-build-script`, `ts-test-pattern-fallback`, `ts-low-coverage*`, `ts-global-threshold-low`, `ts-verbose-conf`, and Vitest: `ts-vitest`, `ts-vitest-test-fails`, `ts-vitest-low-coverage` |
| Python | `python-passing`, `python-requirements-only`, `python-test-fails`, `python-no-tests`, `python-marker-fallback`, `python-low-coverage`, `python-lint-fails`, `python-flask` |
| C# / .NET | `dotnet-xunit` (`.slnx`), `dotnet-sln-only` (classic `.sln`), `dotnet-nunit`, `dotnet-aspnet`, `dotnet-csproj` (flat), `dotnet-global-json`, `dotnet-no-tests`, plus `dotnet-xunit-test-fails`, `-low-coverage`, `-lint-fails` |
| Other Languages | `java-*`, `kotlin-*`, `scala-*`, `go-*`, `rust-*`, `ruby-*`, `php-*`, `swift-*`, `cpp-*`, `elixir-*`; each has a passing project, a `*-no-tests` sibling and, for most, `*-test-fails`, `*-low-coverage` and `*-lint-fails` variants |
| Layout | `monorepo-mixed`, `monorepo-one-fails`, `root-and-sub`, `no-signals`, `too-deep`, `symlinked-subdir`, `hostile-subdir-name`, `hostile-root-dir/…`, `cpp-makefile-without-sources-undetected` |
| Precedence | `ambiguous-ts-over-python`, `ambiguous-java-over-go`, `ambiguous-kotlin-over-java` |
| Config (`.validation.conf`) | `conf-comments-and-blank-lines`, `conf-non-numeric-threshold`, `conf-threshold-over-100`, `conf-bad-language-key`, `conf-injection-attempt` |

## Known limits
- `hostile-subdir-name` and `hostile-root-dir/…` pass with `validate.sh` but not with `validate.ps1`: PowerShell 7 on
  macOS starts in the wrong directory when the directory name contains a backslash (a runtime limit).
- C/C++ has no coverage reader, so its coverage Gate is always SKIPPED.

The results of running both scripts over all of these are in
`code-review-agent/docs/dummy-project-validation-report.md`.
