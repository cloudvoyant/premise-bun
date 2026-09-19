export type CounterKey = 'left' | 'right'

export function updateCount(count: number, key: CounterKey): number {
  return key === 'left' ? count - 1 : count + 1
}

export function counterLabel(count: number): string {
  return `Count  ${count}`
}
