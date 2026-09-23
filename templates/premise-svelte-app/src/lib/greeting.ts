export function greeting(name: string): string {
  const trimmedName = name.trim()
  return `hello ${trimmedName || 'premise-svelte-app'}!`
}
