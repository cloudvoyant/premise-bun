import { Hono } from 'hono'

const app = new Hono()

app.get('/health', (context) => context.json({ status: 'ok' }))
app.get('/api/greeting/:name', (context) =>
  context.json({ message: `Hello, ${context.req.param('name')}!` }),
)

export default app
