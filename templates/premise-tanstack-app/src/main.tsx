import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { RouterProvider } from '@tanstack/react-router'

import './app.css'
import { router } from './router'

const target = document.querySelector<HTMLElement>('#root')

if (!target) {
  throw new Error('missing #root mount element')
}

createRoot(target).render(
  <StrictMode>
    <RouterProvider router={router} />
  </StrictMode>,
)
