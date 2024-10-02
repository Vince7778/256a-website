<script lang="ts">
    import { devMode } from "$lib";
	import { onMount } from "svelte";
	import { slide } from "svelte/transition";

    export let title: string;
    export let sub: boolean = false;

    let body: HTMLDivElement;
    let wordCount: number = 0;
    function countWords() {
        // naive but probably good enough
        wordCount = body?.innerText.split(/\s+/).length ?? 0;
    }

    let minimized = false;
    function minimize() {
        minimized = !minimized;
    }

    onMount(() => {
        countWords();
    })
</script>

<div class="section">
    <div class="section-title" class:sub={sub} class:minimized={minimized}>
        {title}
        {#if !sub}
            <button class="minimize" on:click={minimize}>({minimized ? "expand" : "minimize"})</button>
        {/if}
    </div>
    {#if !minimized}
        <div transition:slide={{ duration: 300, axis: "y" }}>
            <div class="section-body" class:sub={sub} bind:this={body}>
                <slot></slot>
            </div>
            {#if $devMode && !sub}
                <div style="margin-top: 10px; font-family: monospace;">(dev) section word count: {wordCount}</div>
            {/if}
        </div>
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

    .section-title.sub {
        font-size: 1em;
    }

    .section-title.minimized {
        font-weight: normal;
    }

    .section-body {
        display: flex;
        flex-direction: column;
        gap: 1em;

        margin-left: 10px;
        padding: 8px 0px 5px 15px;
        border-left: 1px solid var(--fg-color);
    }

    @media only screen and (min-width: 720px) {
        .section-body {
            max-width: 70%;
        }

        .section-body.sub {
            max-width: 100%;
        }
    }

    .section-body :global(p) {
        margin-top: 0;
        margin-bottom: 0;
    }

    button.minimize {
        border: none;
    }
</style>