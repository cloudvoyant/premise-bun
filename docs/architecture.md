# Architecture

## Overview

`premise-bun` is an external template registry with two publishable CLI starters. Premise owns source discovery, prompting, copying, substitutions, generated-project registration, and lifecycle orchestration. This repository owns the Bun template catalog, the files copied into generated applications, and the narrow npm release automation for `premise-commander` and `premise-opentui`.

## Repository Boundaries

```text
premise.yaml             # Registry identity and template declarations
mise.toml                # Registry-level checks; not a Bun monorepo root
templates/package.json   # Private workspace and shared lint/format dependencies
templates/mise.toml      # Shared Bun tools and aggregate checks
templates/bunfig.toml    # Retained hoisted-linker policy
templates/eslint.config.js # Shared registry lint policy
templates/.prettier*     # Shared formatting policy and ignores
templates/premise-*/     # Template-specific generated-project overlays
README.md                # Template catalog and generation entry points
docs/                    # Registry development documentation
```

The repository root stays outside the nested Bun monorepo. `templates/mise.toml` declares `monorepo_root = true` and discovers `premise-*` package configurations. The useful Bun template tooling is moved into this boundary instead of being deleted: Bun controls workspace installation, ESLint performs aggregate source linting, and Prettier defines the formatting policy. Premise copies files directly under `templates/` into a generated project before the selected template overlay, so these policies have one canonical source copy. This follows the separation proven by `premise-cargo` and prevents registry tasks from being treated as package tasks.

## Template Contract

All five entries use Premise schema `0.1` and `kind: app`, so generated projects land under `apps/<name>`. Shared `bunfig.toml`, ESLint, and Prettier files live once at the `templates/` root. Each template overlay owns its dependencies, Bun tool version, source files, tests, and every task required by `core.ContractTasks("app")` in Premise. ESLint remains an aggregate registry check; standalone template lint tasks continue to use their local TypeScript or framework checker.

`PREMISE_TEMPLATE_TEST=1` changes interactive `run` and `dev` tasks into finite build checks. It also changes publication into `npm pack --dry-run`, so contract tests never publish. Commander and OpenTUI publish release candidates from marked feature-branch pushes and stable packages after merges to `master`; the other three templates keep explicit publication no-ops.

## Premise Integration

Premise registers `cloudvoyant/premise-bun` in its ordered `OfficialSources` list. Explicit remote and local selectors already use the generic registry path; no Bun-specific scaffold code or package-manager schema field is required.

## Publication

`on-commit.yml` runs Premise's registry lifecycle for pull requests and feature branches. A feature-branch push marked `[publish-rc]` invokes the root `publish:rc` task, which gives both CLI packages the same `0.x.y-rc.<run>` version and publishes the `rc` dist-tag. `on-merge.yml` runs the root `on-merge` task, publishes both stable packages with `latest`, and pushes the matching semantic-version tag. Reruns skip package versions that already exist.

The workflows authenticate with the Cloudvoyant `NPM_TOKEN` Actions secret. Package manifests remain unscoped: `premise-commander` and `premise-opentui`.

## Deferred Infrastructure

Deployment adapters, publication for the web/API templates, and standalone binary artifacts remain outside this registry phase.
