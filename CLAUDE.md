# premise-bun Development Rules

## Critical Rules

- Use `mise run <task>` for build, test, lint, format, and run operations; check `mise tasks` before direct commands.
- Keep the repository root as a Premise template registry, not a Bun package or monorepo.
- Keep the Bun monorepo boundary and shared Bun, ESLint, and Prettier tooling under `templates/` only.
- Keep shared `package.json`, `mise.toml`, `bunfig.toml`, ESLint, and Prettier files at the `templates/` root so Premise merges them into the generated client monorepo root; selected template contents belong under `apps/<name>`.
- Every template must implement all Premise app contract tasks: `install`, `build`, `clean`, `test`, `lint`, `lint:fix`, `format`, `format:check`, `env-pull`, `publish:rc`, `publish`, `run`, `dev`, `deploy`, and `e2e`.
- Interactive servers and TUIs must terminate under `PREMISE_TEMPLATE_TEST=1`.
- Keep release infrastructure limited to npm publication for `premise-commander` and `premise-opentui`; do not add deployment, publish the web/API templates, or commit credentials.
- Use Conventional Commits with an imperative subject of at most 72 characters and no AI attribution.

## Template Changes

- Add only files required by the generated project.
- Pin dependency versions and Bun in each template.
- Include at least one behavior test per template.
- Validate an individual template with its Mise tasks, then run `mise run test` at the registry root through the companion Premise binary.
- Update `premise.yaml`, `README.md`, and `docs/architecture.md` whenever the template catalog changes.
- Keep npm package names unscoped. Use the Cloudvoyant `NPM_TOKEN` Actions secret; never write tokens to the repository.
