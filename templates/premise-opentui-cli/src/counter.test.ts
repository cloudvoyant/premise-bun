import { describe, expect, test } from 'bun:test'
import { counterLabel, updateCount } from './counter'

describe('OpenTUI counter', () => {
  test('moves in both directions', () => {
    expect(updateCount(0, 'right')).toBe(1)
    expect(updateCount(0, 'left')).toBe(-1)
  })

  test('formats the rendered label', () => {
    expect(counterLabel(3)).toBe('Count  3')
  })
})
