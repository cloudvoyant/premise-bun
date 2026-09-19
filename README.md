# premise-bun

A Bun template registry for [Premise](https://github.com/cloudvoyant/premise). Developers can generate one of five minimal TypeScript applications alongside Premise's native Go and Cargo templates.

## Templates

| Template | Kind | Description |
| --- | --- | --- |
| `premise-commander-cli` | app | Minimal Commander CLI with one optional name argument. |
| `premise-tanstack-start-app` | app | Minimal React application with TanStack Start server-side rendering. |
| `premise-sveltekit-app` | app | Minimal SvelteKit application with adapter-auto server-side rendering. |
| `premise-opentui-cli` | app | Minimal OpenTUI terminal counter with explicit renderer cleanup. |
| `premise-hono-api` | app | Minimal Hono REST API with health and greeting routes. |

Every template is a standalone Bun project. Shared registry validation tooling lives under `templates/`; retained Bun, ESLint, and Prettier configuration is reused while authoring the registry, and each generated project receives its own Bun and Prettier configuration plus the complete Premise task contract.

## Requirements

- `pm` on `PATH` to list, generate, and validate templates.
- [Mise](https://mise.jdx.dev/) to install Bun 1.4.2.
- Network access to install npm dependencies.

## Generate a Project

```bash
pm generate cloudvoyant/premise-bun
```

Select a template, then enter a lowercase npm-safe project name. To skip the picker, use a fully qualified selector:

```bash
pm generate cloudvoyant/premise-bun:premise-hono-api
```

## Development

See the [development guide](docs/development-guide.md) for local validation and the deferred infrastructure boundary. See [architecture](docs/architecture.md) for the registry layout.

## License

[MIT](LICENSE)
