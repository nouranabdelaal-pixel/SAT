# SAT demo projects: full setup on the Mac

For master after Sessions 22 and 23 (tests fail -> Coverage SKIP; no tests -> Coverage FAIL; lint fail -> Tests and Coverage SKIP).
Run every command in Terminal. The SAT tool itself never installs anything; you install the project tools once.

## 0. First time on this Mac only

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install git python@3.12
git clone https://github.com/rabdelbaky/SAT.git ~/SAT
```

Homebrew prints two `eval ...` lines at the end of its install: run them, or open a new Terminal. Download `sat-demo-projects.zip` into `~/Downloads`.

## 1. Get the code and the demo projects

```bash
cd ~/SAT
git checkout master
git pull
unzip -o ~/Downloads/sat-demo-projects.zip -d ~
D="$HOME/sat-demo-projects"
mkdir -p "$D/reports"
```

## 2. Install the tools (once)

```bash
brew install node go maven openjdk@21
python3.12 -m venv ~/sat-venv
source ~/sat-venv/bin/activate
pip install pytest pytest-cov ruff
```

- The venv gives pytest, pytest-cov and ruff without touching Homebrew's Python. Run `source ~/sat-venv/bin/activate` in every new Terminal window before the demos.
- Maven is needed for 10, 11, 12 and 15 (billing). Without it those show WARN "tool not installed".
- Kotlin (18, 19, 20) brings its own Gradle (`gradlew`), but needs Java 21 and internet the first time.

## 3. Prepare the projects (once)

```bash
export JAVA_HOME="$(brew --prefix openjdk@21)/libexec/openjdk.jdk/Contents/Home"
for p in 06-js-all-pass 07-js-build-fail 08-js-lint-fail 15-monorepo/frontend; do (cd "$D/$p" && npm install --no-audit --no-fund); done
chmod +x "$D"/18-kotlin-all-pass/gradlew "$D"/19-kotlin-lint-fail/gradlew "$D"/20-kotlin-test-fail/gradlew
```

Do NOT run `npm install` in `09-js-missing-deps` or `16-edge-cases/needs-deps`: they show the missing-packages case.

## 4. Run all of them (from ~/SAT)

```bash
cd ~/SAT
source ~/sat-venv/bin/activate
export JAVA_HOME="$(brew --prefix openjdk@21)/libexec/openjdk.jdk/Contents/Home"
D="$HOME/sat-demo-projects"
for p in "$D"/*/; do
  n=$(basename "$p"); [ "$n" = reports ] && continue
  echo "===== $n"
  extra=""; [ "$n" = 16-edge-cases ] && extra="--timeout-tests 20s"
  python pre_llm_checks.py --path "$p" --output "$D/reports/$n.json" $extra
  echo "exit code: $?"
done
```

One project only: `python pre_llm_checks.py --path "$D/03-python-test-fail"`.

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
- WARN "tool not installed": that tool is not on PATH (step 2), or the venv is not active.
- Kotlin Build FAIL with a download error: no internet, or JAVA_HOME is not Java 21.
