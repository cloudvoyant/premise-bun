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
templates/package.json   # Private validation workspace and ESLint dependencies
templates/bunfig.toml    # Shared Bun install policy
templates/eslint.config.js # Aggregate TypeScript lint policy
templates/.prettier*     # Formatting policy copied into generated projects
templates/*/             # Standalone source templates
mise.toml                # Registry development tasks
```

## Development Workflow

1. Edit a template under `templates/`.
2. Run `mise run format` inside that template.
3. Run `mise run format:check`, `mise run lint`, `mise run test`, and `mise run build` inside that template.
4. Run the registry-wide `mise run test` from the repository root with the companion Premise binary on `PATH`.
5. Generate the edited template through a local selector and inspect the standalone result.

```bash
pm generate "$PWD":premise-hono-api
```

Remote selectors always use a repository's default branch. Use an absolute local source while this feature is unmerged.

## Deferred Infrastructure

This repository does not yet contain CI workflows, deployment configuration, npm publication, release credentials, or artifact packaging. Add those only through a separate infrastructure effort after the five template contracts are stable.
