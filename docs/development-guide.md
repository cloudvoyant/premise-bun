# premise-bun Development Guide

## Prerequisites

- [Premise](https://github.com/cloudvoyant/premise) — owns registry discovery and lifecycle validation
- [Mise](https://mise.jdx.dev/) — installs Bun and runs tasks
- Network access to npm packages

## Getting Started

Build the companion Premise worktree, then place its binary first on `PATH`:

```bash
PREMISE_REPO=/path/to/premise/.codevoyant/worktrees/feature/premise-bun
PREMISE_BUN_REPO=/path/to/premise-bun
cd "$PREMISE_REPO"
mise run build
cd "$PREMISE_BUN_REPO"
PATH="$PREMISE_REPO/bin:$PATH" mise run test
```

The root test invokes `pm template test`. Premise enters every declared template, installs Mise tools, runs `install`, and then runs the complete app contract with `PREMISE_TEMPLATE_TEST=1`.

## Project Structure

```text
premise.yaml             # Registry manifest and workspace-file allowlist
mise.toml                # Registry, source, and generated-client tasks
package.json             # Source and generated-client Bun workspace
bunfig.toml              # Shared Bun install policy
eslint.config.js         # Aggregate TypeScript lint policy
.prettier*               # Shared workspace formatting policy
templates/*/             # Template-specific app workspace members
```

## Development Workflow

1. Edit declared shared tooling at the repository root or template-specific files under `templates/<name>/`.
2. Run `mise run format` inside the affected template.
3. Run `mise run format:check`, `mise run lint`, `mise run test`, and `mise run build` inside that template.
4. Run the registry-wide `mise run test` from the repository root with the companion Premise binary on `PATH`.
5. For Commander or OpenTUI changes, run `npm pack --dry-run` in the template and inspect the package contents.
6. Generate the edited template through a local selector and inspect the client monorepo root and its new `apps/<name>` member.

```bash
pm generate "$PWD":premise-hono-api
pm generate "$PWD":premise-svelte-app
pm generate "$PWD":premise-tanstack-app
```

Remote selectors always use a repository's default branch. Use an absolute local source while this feature is unmerged.

The standalone Svelte template uses the direct Svelte Vite plugin and produces `dist/`; it has no SvelteKit configuration. The standalone TanStack template uses React, Vite, and a code-defined root/index route tree; it has no TanStack Start dependency, server bundle, route generator, or generated route tree. Run `mise run build` in either generated app to produce static assets, and use `PREMISE_TEMPLATE_TEST=1 mise run run` or `PREMISE_TEMPLATE_TEST=1 mise run dev` for finite contract checks.

## Publishing

The public npm package names are `premise-commander` and `premise-opentui`. Their template-level `publish:rc` and `publish` tasks require `PREMISE_PUBLISH_VERSION` outside contract-test mode. They build the CLI, update the package version temporarily, skip versions already present on npm, treat npm's immutable-version conflict as an idempotent skip during registry propagation, publish with provenance, and restore the source manifest. Premise selects declared templates with `private: false` and a configured `publishConfig.registry`; visibility (`publishConfig.access`) is a separate property. The current templates expose only Commander and OpenTUI to npm. The root task no longer maintains an independent publication allowlist or creates tags.

The standalone Svelte and TanStack Router templates return successful deferral messages from `publish` and `publish:rc`. Static GitHub artifacts, OCI containers, and a generation questionnaire for selecting between them remain future work.

Feature-branch pushes publish only when the HEAD commit contains `[publish-rc]`. Premise calculates `0.x.y-rc.<GitHub run number>`, then runs eligible template tasks with the `rc` dist-tag. A merge to `master` validates the registry and lets Premise create or reuse the stable tag before invoking the selected templates' `publish` tasks with `latest`. The workflow uses the Premise action; Mise installs Node and Bun. GitHub Actions supplies `NPM_TOKEN` as `NODE_AUTH_TOKEN` to the lifecycle action. The package-manager plugin writes a temporary npm credential file only for package tasks and removes it afterward; GitHub artifact publication cannot read that token.

## Deferred Infrastructure

Deployment configuration, publication for the SPA, TanStack Start, SvelteKit, and Hono templates, questionnaire-selected static archives or OCI containers, and standalone binary artifacts remain deferred.
