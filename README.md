# premise-bun

A Bun template registry for [Premise](https://github.com/cloudvoyant/premise). Developers can generate one of five minimal TypeScript applications alongside Premise's native Go and Cargo templates.

## Templates

| Template                     | Kind | npm package         | Description                                                            |
| ---------------------------- | ---- | ------------------- | ---------------------------------------------------------------------- |
| `premise-commander-cli`      | app  | `premise-commander` | Minimal Commander CLI with one optional name argument.                 |
| `premise-tanstack-start-app` | app  | —                   | Minimal React application with TanStack Start server-side rendering.   |
| `premise-sveltekit-app`      | app  | —                   | Minimal SvelteKit application with adapter-auto server-side rendering. |
| `premise-opentui-cli`        | app  | `premise-opentui`   | Minimal OpenTUI terminal counter with explicit renderer cleanup.       |
| `premise-hono-api`           | app  | —                   | Minimal Hono REST API with health and greeting routes.                 |

Every template becomes a Bun workspace member under `apps/<name>`. Bun, ESLint, Prettier, package, and Mise configuration has one canonical copy at the repository root. `template_registry.workspace_files` explicitly declares those files as generated client workspace inputs. Premise merges them into the client root and copies only the selected `templates/<name>` tree into its app directory. The package and Mise configurations support both the registry's `templates/premise-*` source directories and generated `apps/*` and `libs/*` layouts.

## Requirements

- `pm` on `PATH` to list, generate, and validate templates.
- [Mise](https://mise.jdx.dev/) to install the declared Bun and Node toolchains.
- Network access to install npm dependencies.

## Generate a Project

```bash
pm generate cloudvoyant/premise-bun
```

Select a template, then enter a lowercase npm-safe project name. To skip the picker, use a fully qualified selector:

```bash
pm generate cloudvoyant/premise-bun:premise-hono-api
```

## Published CLIs

The Commander and OpenTUI starters are also public npm executables:

```bash
bunx premise-commander Premise
bunx premise-opentui
```

Feature-branch pushes whose commit message contains `[publish-rc]` publish both packages with an `rc` dist-tag. Merges to `master` validate the registry, publish stable versions with the `latest` dist-tag, and create the matching `vMAJOR.MINOR.PATCH` tag.

## Development

See the [development guide](docs/development-guide.md) for local validation and publication details. See [architecture](docs/architecture.md) for the registry layout.

## License

[MIT](LICENSE)
