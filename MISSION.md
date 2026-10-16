# Mission: Use and Extend Pre-LLM Checks

## Why
Learn to run Pre-LLM Checks confidently on real repositories, understand exactly what its results mean, and identify where its v1 behavior does not yet cover a situation. This will let you use its JSON evidence before AI code reviews and safely improve the tool later.

## Success looks like
- Run a dry run and a real check against a repository.
- Explain the Build, Lint, Tests, and Coverage gates and statuses.
- Read `pre-llm-report.json` and distinguish code failures from setup warnings.
- Predict important edge-case behavior and identify known gaps.
- Add or modify a language rule or feature without violating the safety contract.

## Constraints
- Lessons should be short, practical, and grounded in this repository's code and documentation.
- Use Windows PowerShell commands first, with equivalent concepts for macOS/Linux.

## Out of scope
- Building CI integration, sandboxing, parallel execution, or coverage thresholds in the first lessons.
