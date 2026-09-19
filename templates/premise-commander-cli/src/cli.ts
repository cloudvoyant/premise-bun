import { Command } from 'commander'

export function greeting(name: string): string {
  return `Hello, ${name}!`
}

export function createProgram(write: (message: string) => void = console.log): Command {
  return new Command()
    .name('premise-commander-cli')
    .description('A minimal Commander CLI powered by Bun')
    .version('0.1.0')
    .argument('[name]', 'name to greet', 'world')
    .action((name: string) => write(greeting(name)))
}
