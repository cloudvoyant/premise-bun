#!/usr/bin/env bun

import { createProgram } from './cli'

await createProgram().parseAsync(process.argv)
