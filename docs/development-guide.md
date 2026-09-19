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
premise.yaml             # Template-registry manifest
templates/mise.toml      # Shared Bun validation toolchain
templates/package.json   # Private workspace and shared lint/format dependencies
templates/bunfig.toml    # Shared Bun install policy
templates/eslint.config.js # Aggregate TypeScript lint policy
templates/.prettier*     # Formatting policy copied into generated projects
templates/*/             # Template-specific source overlays
mise.toml                # Registry development tasks
```

## Development Workflow

1. Edit shared tooling at the `templates/` root or a template-specific overlay under `templates/<name>/`.
2. Run `mise run format` inside the affected template.
3. Run `mise run format:check`, `mise run lint`, `mise run test`, and `mise run build` inside that template.
4. Run the registry-wide `mise run test` from the repository root with the companion Premise binary on `PATH`.
5. For Commander or OpenTUI changes, run `npm pack --dry-run` in the template and inspect the package contents.
6. Generate the edited template through a local selector and inspect the standalone result.

```bash
pm generate "$PWD":premise-hono-api
```

Remote selectors always use a repository's default branch. Use an absolute local source while this feature is unmerged.

## Publishing

The public npm package names are `premise-commander` and `premise-opentui`. Their template-level `publish:rc` and `publish` tasks require `PREMISE_PUBLISH_VERSION` outside contract-test mode. They build the CLI, update the package version temporarily, skip versions already present on npm, publish with provenance, and restore the source manifest.

Feature-branch pushes publish only when the HEAD commit contains `[publish-rc]`. The root task computes `0.x.y-rc.<GitHub run number>` with svu and publishes both packages with the `rc` dist-tag. A merge to `master` runs the full registry validation, publishes both stable packages with `latest`, and pushes the corresponding version tag. GitHub Actions reads npm credentials from the Cloudvoyant `NPM_TOKEN` secret.

## Deferred Infrastructure

Deployment configuration, publication for TanStack Start, SvelteKit, and Hono, and standalone binary artifacts remain deferred.
