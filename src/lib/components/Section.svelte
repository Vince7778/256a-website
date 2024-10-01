<script lang="ts">
    import { devMode } from "$lib";
	import { onMount } from "svelte";

    export let title: string;

    let body: HTMLDivElement;
    let wordCount: number = 0;
    function countWords() {
        // naive but probably good enough
        wordCount = body?.innerText.split(/\s+/).length ?? 0;
    }

    onMount(() => {
        countWords();
    })
</script>

<div class="section">
    <div class="section-title">{title}</div>
    <div class="section-body" bind:this={body}>
        <slot></slot>
    </div>
    {#if $devMode}
        <div style="margin-top: 10px; font-family: monospace;">(dev) section word count: {wordCount}</div>
    {/if}
</div>

<style>
    .section {
        margin-bottom: 20px;
    }

    .section-title {
        font-size: 1.5em;
        font-weight: bold;
        margin-bottom: 5px;
    }

    .section-body {
        display: flex;
        flex-direction: column;
        gap: 1em;

        margin-left: 10px;
        padding: 8px 0px 5px 15px;
        border-left: 2px solid var(--fg-color);
    }

    @media only screen and (min-width: 720px) {
        .section-body {
            max-width: 70%;
        }
    }

    .section-body :global(p) {
        margin-top: 0;
        margin-bottom: 0;
    }
</style>