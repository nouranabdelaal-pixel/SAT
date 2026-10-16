# SAT demo projects: full setup on Windows

For master after Sessions 22 and 23 (tests fail -> Coverage SKIP; no tests -> Coverage FAIL; lint fail -> Tests and Coverage SKIP).
Run every command in PowerShell. The SAT tool itself never installs anything; you install the project tools once.

## 0. First time on this PC only

```powershell
winget install -e --id Git.Git
winget install -e --id Python.Python.3.12
winget install -e --id OpenJS.NodeJS.LTS
winget install -e --id GoLang.Go
winget install -e --id EclipseAdoptium.Temurin.21.JDK
winget install -e --id Apache.Maven
git clone https://github.com/rabdelbaky/SAT.git "$env:USERPROFILE\SAT"
```

Close PowerShell and open a new one after installing, so the new tools are on PATH. If `winget` has no Maven package on your PC, download it from maven.apache.org, unzip it, and add its `bin` folder to PATH. Download `sat-demo-projects.zip` into your Downloads folder.

## 1. Get the code and the demo projects

```powershell
cd "$env:USERPROFILE\SAT"
git checkout master
git pull
Expand-Archive "$env:USERPROFILE\Downloads\sat-demo-projects.zip" -DestinationPath "$env:USERPROFILE" -Force
$D = "$env:USERPROFILE\sat-demo-projects"
New-Item -ItemType Directory "$D\reports" -Force | Out-Null
```

## 2. Install the Python tools (once)

```powershell
py -3 -m pip install pytest pytest-cov ruff
```

Always run SAT with `py -3`, not `python` (another Python may be first on PATH).

## 3. Prepare the projects (once)

```powershell
foreach ($p in "06-js-all-pass","07-js-build-fail","08-js-lint-fail","15-monorepo\frontend") { Push-Location "$D\$p"; npm install --no-audit --no-fund; Pop-Location }
```

Do NOT run `npm install` in `09-js-missing-deps` or `16-edge-cases\needs-deps`: they show the missing-packages case.
Kotlin (18, 19, 20) uses `gradlew.bat`, which downloads Gradle the first time. It needs internet and Java 21; if the download is blocked, Build shows FAIL with a download error (network, not the project).

## 4. Run all of them (from the SAT folder)

```powershell
cd "$env:USERPROFILE\SAT"
$D = "$env:USERPROFILE\sat-demo-projects"
Get-ChildItem $D -Directory | Where-Object Name -ne "reports" | ForEach-Object {
  "===== $($_.Name)"
  if ($_.Name -eq "16-edge-cases") { py -3 pre_llm_checks.py --path $_.FullName --timeout-tests 20s --output "$D\reports\$($_.Name).json" }
  else { py -3 pre_llm_checks.py --path $_.FullName --output "$D\reports\$($_.Name).json" }
  "exit code: $LASTEXITCODE"
}
```

One project only: `py -3 pre_llm_checks.py --path "$D\03-python-test-fail"`.

## 5. What you should see

| # | Project | Build | Lint | Tests | Coverage | Exit |
|---|---|---|---|---|---|---|
| 01 | python-all-pass | SKIP | PASS | PASS | 100.0% | 0 |
| 02 | python-lint-fail | SKIP | FAIL | SKIP | SKIP | 1 |
| 03 | python-test-fail | SKIP | PASS | FAIL | SKIP | 1 |
| 04 | python-no-linter | SKIP | WARN | PASS | 100.0% | 0 |
| 05 | python-no-tests | SKIP | PASS | SKIP | FAIL | 1 |
| 06 | js-all-pass | PASS | PASS | PASS | 100.0% | 0 |
| 07 | js-build-fail | FAIL | SKIP | SKIP | SKIP | 1 |
| 08 | js-lint-fail | PASS | FAIL | SKIP | SKIP | 1 |
| 09 | js-missing-deps | SKIP | SKIP | SKIP | SKIP | 0 |
| 10 | java-all-pass | PASS | PASS | PASS | 100.0% | 0 |
| 11 | java-build-fail | FAIL | SKIP | SKIP | SKIP | 1 |
| 12 | java-test-fail | PASS | PASS | FAIL | SKIP | 1 |
| 13 | go-all-pass | PASS | PASS | PASS | 85.7% | 0 |
| 14 | go-test-fail | PASS | PASS | FAIL | SKIP | 1 |
| 15 | monorepo | 3 rows, see below | | | | 0 |
| 16 | edge-cases | 7 rows, see below | | | | 1 |
| 17 | no-project | no table: "No supported projects found." | | | | 3 |
| 18 | kotlin-all-pass | PASS | PASS | PASS | 100.0% | 0 |
| 19 | kotlin-lint-fail | PASS | FAIL | SKIP | SKIP | 1 |
| 20 | kotlin-test-fail | PASS | PASS | FAIL | SKIP | 1 |

05 also prints `. / coverage: FAIL  no tests found`.

**15-monorepo:** backend (python) `SKIP PASS PASS 100.0%`; frontend (javascript) `SKIP PASS PASS 100.0%`; services/billing (java) `PASS WARN PASS 100.0%`.

**16-edge-cases:**

| Project | Build | Lint | Tests | Coverage |
|---|---|---|---|---|
| broken-service | FAIL | SKIP | SKIP | SKIP |
| failing-tests | SKIP | PASS | FAIL | SKIP |
| needs-deps | SKIP | SKIP | SKIP | SKIP |
| shop-api | SKIP | WARN | PASS | SKIP |
| slow-tests | SKIP | WARN | TIMEOUT | SKIP |
| tool-missing | SKIP | WARN | PASS | SKIP |
| web | PASS | FAIL | SKIP | SKIP |

Every run also shows the `gitignore_missing` warning. That is expected.

## If something looks different

- All SKIP plus `dependencies_missing` on a JS project: `npm install` was not run there (step 3).
- WARN "tool not installed": that tool is not on PATH. Open a new PowerShell after installing.
- Kotlin Build FAIL with a download error: the Gradle download is blocked, or Java 21 is not the default `java`.
