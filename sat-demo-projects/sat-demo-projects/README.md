# SAT demo projects

20 small "shop cart" projects. Each one proves one behaviour of Pre-LLM Checks.
All results below come from real runs (Python 3.13, ruff, pytest + pytest-cov, Node 22 with ESLint 9 / Jest 29 / TypeScript 5, Maven 3.9 + JDK 21, Go, Gradle 8.14 + Kotlin 2.0 with detekt / ktlint / JaCoCo / Kover).

## Setup on Windows (once)

You install the project tools yourself. The SAT tool never installs anything.

```powershell
Expand-Archive "$env:USERPROFILE\Downloads\sat-demo-projects.zip" -DestinationPath "$env:USERPROFILE" -Force
$D = "$env:USERPROFILE\sat-demo-projects"
python -m pip install pytest pytest-cov ruff
foreach ($p in "06-js-all-pass","07-js-build-fail","08-js-lint-fail","15-monorepo\frontend") { Push-Location "$D\$p"; npm install --no-audit --no-fund; Pop-Location }
```
Do NOT run `npm install` in `09-js-missing-deps` (that project proves the missing-packages case).
Maven downloads its plugins the first time (needs internet). Go projects need `go` on PATH; without it they show WARN "tool not installed".
Kotlin projects (18-20) bring their own Gradle (`gradlew`): it downloads Gradle 8.14.3 and the plugins the first time, so it needs internet and Java 21. See "Kotlin projects" below.

## Run all of them (in your SAT folder)

```powershell
$D = "$env:USERPROFILE\sat-demo-projects"
New-Item -ItemType Directory "$D\reports" -Force | Out-Null
Get-ChildItem $D -Directory | Where-Object Name -ne "reports" | ForEach-Object {
  "===== $($_.Name)"
  if ($_.Name -eq "16-edge-cases") { py -3 pre_llm_checks.py --path $_.FullName --timeout-tests 20s --output "$D\reports\$($_.Name).json" }
  else { py -3 pre_llm_checks.py --path $_.FullName --output "$D\reports\$($_.Name).json" }
  "exit code: $LASTEXITCODE"
}
```
Reports land in `sat-demo-projects\reports\`. One project at a time: `py -3 pre_llm_checks.py --path "$D\03-python-test-fail"`.

## Expected results

| # | Project | What it proves | Build | Lint | Tests | Coverage | Exit |
|---|---|---|---|---|---|---|---|
| 01 | python-all-pass | ruff + pytest + coverage all found and pass | SKIP | PASS | PASS | 100.0% | 0 |
| 02 | python-lint-fail | ruff finds an unused import | SKIP | FAIL | PASS | 100.0% | 1 |
| 03 | python-test-fail | a real bug fails a test; fake `password=hunter2` is masked as `password=***` | SKIP | PASS | FAIL | FAIL | 1 |
| 04 | python-no-linter | no ruff config: no linter | SKIP | WARN | PASS | 100.0% | 0 |
| 05 | python-no-tests | pytest set up but no test files | SKIP | PASS | FAIL | SKIP | 1 |
| 06 | js-all-pass | tsc + ESLint + Jest + coverage; risky scripts (`dev`, `lint:fix`, `format --fix`, `test:watch`) skipped | PASS | PASS | PASS | 100.0% | 0 |
| 07 | js-build-fail | TypeScript type error: build gate | FAIL | SKIP | SKIP | SKIP | 1 |
| 08 | js-lint-fail | ESLint unused variable | PASS | FAIL | PASS | 100.0% | 1 |
| 09 | js-missing-deps | no node_modules: setup problem, not a code failure | SKIP | SKIP | SKIP | SKIP | 0 |
| 10 | java-all-pass | Maven compile + Checkstyle + JUnit + JaCoCo | PASS | PASS | PASS | 100.0% | 0 |
| 11 | java-build-fail | compile error: build gate | FAIL | SKIP | SKIP | SKIP | 1 |
| 12 | java-test-fail | a real bug fails a JUnit test | PASS | PASS | FAIL | 100.0% | 1 |
| 13 | go-all-pass | go build + go vet + go test + cover | PASS | PASS | PASS | 85.7% | 0 |
| 14 | go-test-fail | a real bug fails a Go test | PASS | PASS | FAIL | FAIL | 1 |
| 15 | monorepo | 3 projects in one repo, see below | | | | | 0 |
| 16 | edge-cases | 7 projects: timeout, tool missing, secrets, ignore, see below | | | | | 1 |
| 17 | no-project | only a README | (no table: "No supported projects found.") | | | | 3 |
| 18 | kotlin-all-pass | Gradle assemble + detekt + ktlint + tests + JaCoCo | PASS | PASS | PASS | 100.0% | 0 |
| 19 | kotlin-lint-fail | detekt finds a wildcard import and an unused value (ktlint fails too) | PASS | FAIL | PASS | 100.0% | 1 |
| 20 | kotlin-test-fail | a real bug (`/ 10` instead of `/ 100`) fails a test | PASS | PASS | FAIL | FAIL | 1 |

**15-monorepo** (warnings: `tools: no_project` for a Ruby file with no Gemfile, `analysis: unsupported_extension` for an R file; `build/` is never scanned):

| Project | Build | Lint | Tests | Coverage |
|---|---|---|---|---|
| backend (python) | SKIP | PASS | PASS | 100.0% |
| frontend (javascript) | SKIP | PASS | PASS | 100.0% |
| services/billing (java) | PASS | WARN | PASS | 100.0% |

**16-edge-cases** (run with `--timeout-tests 20s`; `legacy/` is ignored by pre-llm.toml; `API_KEY` and `password` are masked; see its own README):

| Project | Build | Lint | Tests | Coverage |
|---|---|---|---|---|
| broken-service | FAIL | SKIP | SKIP | SKIP |
| failing-tests | SKIP | PASS | FAIL | SKIP |
| needs-deps | SKIP | SKIP | SKIP | SKIP |
| shop-api | SKIP | WARN | PASS | SKIP |
| slow-tests | SKIP | WARN | TIMEOUT | SKIP |
| tool-missing | SKIP | WARN | PASS | SKIP |
| web | PASS | FAIL | PASS | WARN |

Every run also shows the `gitignore_missing` warning (no .gitignore in these folders). That is expected.

Extra tries:
- Ctrl+C: run 16-edge-cases without `--timeout-tests` and press Ctrl+C while it waits on slow-tests. Exit code 130, report status `interrupted`.
- `--lint-anyway` on 11-java-build-fail: Lint runs (PASS) even though Build failed.
- `--dry-run` on any folder: lists the commands without running them.

## Kotlin projects (18, 19, 20)

Each has `build.gradle.kts` with four tool plugins: **detekt** and **ktlint** (lint), **JaCoCo** and **Kover** (coverage).
SAT runs: `gradlew assemble` (build), `gradlew detekt` and `gradlew ktlintCheck` (lint), `gradlew test` (tests), `gradlew jacocoTestReport` (coverage, read from `build/reports/jacoco/test/jacocoTestReport.xml`).
SAT does not run or read Kover yet (no Kover rule in languages.toml); Kover is in the build so you can show it by hand: `./gradlew koverXmlReport` writes `build/reports/kover/report.xml` (also 100%).

Run on the Mac, from your SAT folder (Gradle 8.14 does not run on Java 27, so point it at Java 21 first):

```bash
export JAVA_HOME="$(brew --prefix openjdk@21)/libexec/openjdk.jdk/Contents/Home"
unzip -o ~/Downloads/sat-demo-projects.zip -d ~
D="$HOME/sat-demo-projects"
mkdir -p "$D/reports"
chmod +x "$D"/18-kotlin-all-pass/gradlew "$D"/19-kotlin-lint-fail/gradlew "$D"/20-kotlin-test-fail/gradlew
for p in 18-kotlin-all-pass 19-kotlin-lint-fail 20-kotlin-test-fail; do echo "===== $p"; python3.12 pre_llm_checks.py --path "$D/$p" --output "$D/reports/$p.json"; echo "exit code: $?"; done
```

On Windows it may work too (JDK 21 is there; `gradlew.bat` downloads Gradle itself). If the download is blocked, Build shows FAIL with a download error: that is the network, not the project.

## After Session 22 (tests fail -> Coverage SKIP; no tests -> Tests SKIP, Coverage FAIL)

Once Session 22 is on master, these rows change (checked in the cloud with the change applied). Every other row stays the same.

| # | Project | Tests | Coverage | Exit |
|---|---|---|---|---|
| 03 | python-test-fail | FAIL | SKIP (was FAIL) | 1 |
| 05 | python-no-tests | SKIP (was FAIL) | FAIL (was SKIP); Details: `. / coverage: FAIL  no tests found` | 1 |
| 12 | java-test-fail | FAIL | SKIP (was 100.0%) | 1 |
| 14 | go-test-fail | FAIL | SKIP (was FAIL) | 1 |
| 20 | kotlin-test-fail | FAIL | SKIP (was FAIL) | 1 |

In 16-edge-cases, failing-tests and slow-tests already show Coverage SKIP; only the report reason changes (`tests_failed`).

## Known gaps these projects show (tool behaviour, not mistakes in the projects)
1. **05-python-no-tests shows Tests FAIL.** pytest exits with code 5 ("no tests ran"). Other languages show SKIP (`no_tests_found`) for this; Python has no such rule yet. *Fixed by Session 22.*
2. **Coverage after failing tests differs by language.** Python and Go show Coverage FAIL (the coverage run re-runs the failing tests). Java shows 100.0% (JaCoCo reads the data the failing run left behind). *Fixed by Session 22: all show SKIP.*
3. **09 and 16/needs-deps show SKIP, not WARN, with no Details line.** The reason (`dependencies_missing`) is only in the Warnings list and the report.
4. **16/web coverage WARN.** Node's built-in coverage summary (`# all files | 100.00 |`) is not recognised.
