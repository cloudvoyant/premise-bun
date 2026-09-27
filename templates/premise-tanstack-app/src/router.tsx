import { createRootRoute, createRoute, createRouter, Outlet } from '@tanstack/react-router'

import { greeting } from './lib/greeting'

function RootComponent() {
  return <Outlet />
}

function IndexComponent() {
  return (
    <main aria-labelledby="app-title">
      <p className="eyebrow">React + TanStack Router</p>
      <h1 id="app-title">{greeting('')}</h1>
      <p>
        A client-only application with code-defined routing, ready to build into <code>dist/</code>.
      </p>
    </main>
  )
}

const rootRoute = createRootRoute({
  component: RootComponent,
})

const indexRoute = createRoute({
  getParentRoute: () => rootRoute,
  path: '/',
  component: IndexComponent,
})

const routeTree = rootRoute.addChildren([indexRoute])

export const router = createRouter({ routeTree })

declare module '@tanstack/react-router' {
  interface Register {
    router: typeof router
  }
}
