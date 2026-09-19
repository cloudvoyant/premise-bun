# Architecture

## Overview

`premise-bun` is a data-only external template registry. Premise owns source discovery, prompting, copying, substitutions, generated-project registration, and lifecycle orchestration. This repository owns only the Bun template catalog and the files copied into generated applications.

## Repository Boundaries

```text
premise.yaml             # Registry identity and template declarations
mise.toml                # Registry-level checks; not a Bun monorepo root
templates/package.json   # Private Bun validation workspace and ESLint dependencies
templates/mise.toml      # Shared Bun tools and aggregate checks
templates/bunfig.toml    # Retained hoisted-linker policy
templates/eslint.config.js # Shared registry lint policy
templates/.prettier*     # Shared formatting policy and ignores
templates/premise-*/     # Standalone generated-project overlays
README.md                # Template catalog and generation entry points
docs/                    # Registry development documentation
```

The repository root stays outside the nested Bun monorepo. `templates/mise.toml` declares `monorepo_root = true` and discovers `premise-*` package configurations. The useful Bun template tooling is moved into this boundary instead of being deleted: Bun controls workspace installation, ESLint performs aggregate source linting, and Prettier defines the formatting policy copied into generated projects. This follows the separation proven by `premise-cargo` and prevents registry tasks from being treated as package tasks.

## Template Contract

All five entries use Premise schema `0.1` and `kind: app`, so generated projects land under `apps/<name>`. Each template owns its dependencies, copied `bunfig.toml` and Prettier policy, Bun tool version, source files, tests, and every task required by `core.ContractTasks("app")` in Premise. ESLint remains an aggregate registry check; standalone template lint tasks continue to use their local TypeScript or framework checker.

`PREMISE_TEMPLATE_TEST=1` changes interactive `run` and `dev` tasks into finite build checks. Publication and deployment tasks are explicit no-ops until infrastructure is designed separately.

## Premise Integration

Premise registers `cloudvoyant/premise-bun` in its ordered `OfficialSources` list. Explicit remote and local selectors already use the generic registry path; no Bun-specific scaffold code or package-manager schema field is required.

## Deferred Infrastructure

GitHub Actions, deployment adapters, npm publication, stable and release-candidate package coordination, credentials, and binary artifact policy are outside this registry phase.
