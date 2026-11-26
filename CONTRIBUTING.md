# Contributing Guidelines

Contributions are welcome via GitHub pull requests. Follow these standards to keep every published chart predictable, schema-valid, and independently versioned (see the [repository overview](README.md)).

## Before you begin

Install [Helm](https://helm.sh/docs/intro/install/) (v3.14+ or v4.x) and fork or branch from `main`:

```bash
git checkout -b feat/describe-your-change
```

## Chart authoring requirements

- **Single-chart scope:** Limit each pull request to one chart under `charts/` unless updating shared repository documentation.
- **Explicit SemVer bump:** Every modification to a chart under `charts/<name>/` MUST increment `version` in `Chart.yaml` according to Semantic Versioning 2.0.0 so `chart-releaser` publishes a new artifact cleanly.
- **Avoid breaking live workloads:** Preserve backwards-compatible defaults when extending existing charts unless intentionally bumping a MAJOR version with clear migration notes.
- **Document new values:** Update the corresponding chart `README.md` (and `CHANGELOG.md` when present) whenever values or template behaviors change.

## Local validation

Run Helm lint against the modified chart before opening a pull request:

```bash
helm lint charts/<chart-name>
```

Verify manifest rendering succeeds cleanly with representative values:

```bash
helm template pr-check charts/<chart-name> --values charts/<chart-name>/values.yaml
```

> [!IMPORTANT]
> Pull requests containing hardcoded credentials, internal client domains, or floating `:latest` image tags in chart defaults will not be accepted.

## What's next

- Review the per-chart tagging and GitHub Pages publishing model in the [Release process](docs/release-process.md).
- Report security issues privately according to the [Security policy](SECURITY.md).
