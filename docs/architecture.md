# Architecture

## Overview

`premise-bun` is an external template registry with two publishable CLI starters. Premise owns source discovery, prompting, copying, substitutions, generated-project registration, version planning, tagging, and lifecycle orchestration. This repository owns the Bun template catalog, generated application files, and the npm publish tasks run for eligible packages.

## Repository Boundaries

```text
premise.yaml             # Registry declarations and explicit workspace files
mise.toml                # Registry and generated-client tools and tasks
package.json             # Source and generated-client Bun workspace
bunfig.toml              # Shared hoisted-linker policy
eslint.config.js         # Shared workspace lint policy
.prettier*               # Shared formatting policy and ignores
templates/premise-*/     # Template-specific app workspace members
README.md                # Template catalog and generation entry points
docs/                    # Registry development documentation
```

The repository root is both the registry development workspace and the canonical generated-client workspace policy. Root `mise.toml` discovers the registry's `templates/premise-*` sources and generated client projects under `apps/*` and `libs/*`. Bun controls workspace installation, ESLint performs aggregate source linting, and Prettier defines the formatting policy. Premise copies or merges only the root files explicitly named by `template_registry.workspace_files`, then copies the selected `templates/<name>` tree to `apps/<name>`. Registry-only files such as `premise.yaml` and workflows remain outside generated clients.

## Template Contract

All seven entries use Premise schema `0.2` and `kind: app`, so selected template contents land under `apps/<name>`. Shared `package.json`, `mise.toml`, `bunfig.toml`, ESLint, and Prettier files live once at the repository root and become the client monorepo root because the manifest declares them. Each selected template owns its dependencies, Bun tool version, source files, tests, and every task required by `core.ContractTasks("app")` in Premise. Root checks validate the aggregate workspace; app checks continue to use their local TypeScript or framework checker.

The Svelte SPA uses `@sveltejs/vite-plugin-svelte` directly and has no SvelteKit adapter or server output. The TanStack Router SPA defines its root and index routes in TypeScript and does not use TanStack Start, a route generator plugin, or `routeTree.gen.ts`. Both client-only templates build static assets into `dist/`; the existing SvelteKit and TanStack Start templates remain the server-capable choices.

`PREMISE_TEMPLATE_TEST=1` changes interactive `run` and `dev` tasks into finite build checks. Commander and OpenTUI change publication into `npm pack --dry-run`, so contract tests never publish. They publish release candidates from marked feature-branch pushes and stable packages after merges to `master`; the other five templates keep explicit publication no-ops.

## Premise Integration

Premise registers `cloudvoyant/premise-bun` in its ordered `OfficialSources` list. Explicit remote and local selectors already use the generic registry path; no Bun-specific scaffold code or package-manager schema field is required.

## Publication

Each workflow delegates its lifecycle to the Premise action. Mise installs Node and Bun without separate setup actions. Premise's Bun package-manager plugin selects declared templates whose `package.json` has `private: false` and a `publishConfig.registry`. A feature-branch push marked `[publish-rc]` computes the shared `0.x.y-rc.<run>` version and invokes each eligible template's `publish:rc` task with the `rc` dist-tag. On merges to `master`, the root `on-merge` task validates the registry; Premise creates or reuses the stable tag before invoking each eligible template's `publish` task with `latest`. The template tasks skip versions already present on npm. `publishConfig.access` describes visibility, not whether the package can be published. GoReleaser has no Bun archive target; skipping that step does not skip npm. Private apps, static-site uploads, and OCI deployment have no configured destination.

The workflows authenticate with the Cloudvoyant `NPM_TOKEN` Actions secret. Package manifests remain unscoped: `premise-commander` and `premise-opentui`.

## Deferred Infrastructure

Deployment adapters, static GitHub archives, OCI containers, questionnaire-selected publication for the web/API templates, and standalone binary artifacts remain outside this registry phase.
