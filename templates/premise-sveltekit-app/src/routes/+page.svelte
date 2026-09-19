<script lang="ts">
  import { greeting } from '$lib/greeting'
</script>

<svelte:head>
  <title>premise-sveltekit-app</title>
  <meta name="description" content="A minimal server-rendered SvelteKit application" />
</svelte:head>

<main>
  <h1>{greeting('SvelteKit')}</h1>
  <p>This page is rendered on the server and hydrated in the browser.</p>
</main>
