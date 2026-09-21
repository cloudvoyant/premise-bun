# Architecture

## Overview

`premise-bun` is an external template registry with two publishable CLI starters. Premise owns source discovery, prompting, copying, substitutions, generated-project registration, and lifecycle orchestration. This repository owns the Bun template catalog, the files copied into generated applications, and the narrow npm release automation for `premise-commander` and `premise-opentui`.

## Repository Boundaries

```text
premise.yaml             # Registry identity and template declarations
mise.toml                # Registry-level checks; not a Bun monorepo root
templates/package.json   # Shared client workspace and lint/format dependencies
templates/mise.toml      # Shared Bun monorepo tools and aggregate checks
templates/bunfig.toml    # Shared hoisted-linker policy
templates/eslint.config.js # Shared workspace lint policy
templates/.prettier*     # Shared formatting policy and ignores
templates/premise-*/     # Template-specific app workspace members
README.md                # Template catalog and generation entry points
docs/                    # Registry development documentation
```

The repository root stays outside the nested Bun monorepo. `templates/mise.toml` declares `monorepo_root = true` and discovers both the registry's `premise-*` source configurations and generated client projects under `apps/*` and `libs/*`. Bun controls workspace installation, ESLint performs aggregate source linting, and Prettier defines the formatting policy. Premise merges files directly under `templates/` into the client workspace root, then copies the selected template to `apps/<name>`. This keeps one canonical source for the generated Bun monorepo policy without treating registry-level release tasks as package tasks.

## Template Contract

All five entries use Premise schema `0.1` and `kind: app`, so selected template contents land under `apps/<name>`. Shared `package.json`, `mise.toml`, `bunfig.toml`, ESLint, and Prettier files live once at the `templates/` root and become the client monorepo root. Each selected template owns its dependencies, Bun tool version, source files, tests, and every task required by `core.ContractTasks("app")` in Premise. Root checks validate the aggregate workspace; app checks continue to use their local TypeScript or framework checker.

`PREMISE_TEMPLATE_TEST=1` changes interactive `run` and `dev` tasks into finite build checks. It also changes publication into `npm pack --dry-run`, so contract tests never publish. Commander and OpenTUI publish release candidates from marked feature-branch pushes and stable packages after merges to `master`; the other three templates keep explicit publication no-ops.

## Premise Integration

Premise registers `cloudvoyant/premise-bun` in its ordered `OfficialSources` list. Explicit remote and local selectors already use the generic registry path; no Bun-specific scaffold code or package-manager schema field is required.

## Publication

Each workflow delegates its complete lifecycle to the major-versioned Premise action. Mise installs the declared Node, Bun, and release tools without separate setup actions. A feature-branch push marked `[publish-rc]` invokes the root `publish:rc` task, which gives both CLI packages the same `0.x.y-rc.<run>` version and publishes the `rc` dist-tag. `on-merge.yml` runs the root `on-merge` task, which validates the registry, publishes both stable packages with `latest`, and pushes the matching semantic-version tag. Reruns skip package versions that already exist.

The workflows authenticate with the Cloudvoyant `NPM_TOKEN` Actions secret. Package manifests remain unscoped: `premise-commander` and `premise-opentui`.

## Deferred Infrastructure

Deployment adapters, publication for the web/API templates, and standalone binary artifacts remain outside this registry phase.
