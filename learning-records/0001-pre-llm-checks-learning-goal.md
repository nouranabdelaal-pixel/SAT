# Learning goal established

The learner wants a practical, stateful understanding of Pre-LLM Checks: how to run it, what its features do, which edge cases are handled, and which gaps remain. Future lessons should prioritize hands-on command usage and interpreting real reports before deep implementation details.

Demonstrated understanding through a real fixture: a repository with root `package.json`, `frontend/package.json`, and `backend/pyproject.toml` was discovered as exactly three projects. The dry-run showed commands per project, and the real run produced three table rows and `project_count: 3` in the JSON report.

The next learning goal is to compare SAT with AI review platforms and Black Duck, then reason about safe extensions. The user requested a slide-style comparison before being taught the tools, so future sessions should begin with roles and boundaries: SAT gathers execution evidence, AI reviewers inspect code semantically, and Black Duck focuses on software-composition/security risk.

The user requested a one-tool-at-a-time explanation before deeper comparison. The next lesson is therefore a nine-slide deck covering CodeRabbit, Greptile, Graphite, Qodo Merge, Black Duck SCA, SAT, and the distinctions between AI review, SAST, SCA, and execution evidence.
