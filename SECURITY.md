# Security Policy

## Before you begin

Do not disclose unpatched security vulnerabilities in public GitHub issues, pull requests, or discussion threads.

## Supported versions

Security fixes are released on the latest MINOR/PATCH version of each *Active* chart listed in the [Chart catalog](docs/chart-catalog.md). Older versions remain in the index for backwards compatibility but do not receive backports unless explicitly noted.

## Reporting a vulnerability

Report suspected security issues privately using one of the following channels:

- **GitHub Security Advisories:** Open a private advisory under the **Security** tab of this repository.
- **Maintainer email:** Send details to `c3.fredy@gmail.com` with subject `[SECURITY][helm-charts] <chart-name>`.

Include the affected chart name and version, minimal reproduction values, and rendered template output demonstrating the risk. Reports are acknowledged within 72 hours, and validated fixes are released as explicit semantic version bumps with changelog notes.

## What's next

- Browse active supported charts in the [Chart catalog](docs/chart-catalog.md).
- Check contribution rules in [Contributing guidelines](CONTRIBUTING.md).
