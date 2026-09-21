# premise-bun Development Rules

## Critical Rules

- Use `mise run <task>` for build, test, lint, format, and run operations; check `mise tasks` before direct commands.
- Keep the repository root as both the Premise registry development workspace and the Bun source workspace.
- Keep shared Bun, ESLint, Prettier, package, and Mise configuration at the repository root.
- Declare every generated client-root input explicitly in `template_registry.workspace_files`; selected template contents belong under `templates/<name>` in source and `apps/<name>` after generation.
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
