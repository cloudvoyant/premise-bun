import { describe, expect, test } from 'bun:test'
import app from './app'

describe('Hono API', () => {
  test('reports health', async () => {
    const response = await app.request('/health')
    expect(response.status).toBe(200)
    expect(await response.json()).toEqual({ status: 'ok' })
  })

  test('returns a named greeting', async () => {
    const response = await app.request('/api/greeting/Premise')
    expect(response.status).toBe(200)
    expect(await response.json()).toEqual({ message: 'Hello, Premise!' })
  })
})
