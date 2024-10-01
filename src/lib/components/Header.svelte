<script lang="ts">
	import Link from "./Link.svelte";
    import { pageTitle, devMode } from "$lib";

    function toggleDev() {
        $devMode = !$devMode;
    }
</script>

<svelte:head>
    <title>{$pageTitle || "256a"}</title>
</svelte:head>

<div class="header">
    <div class="title"><Link href="/" hide>Music 256A: Conor Kennedy{$pageTitle ? " - " + $pageTitle : ""}</Link></div>
    <div class="header-right">
        <button on:click={toggleDev}>dev mode {$devMode ? "on" : "off"}</button>
    </div>
</div>

<style>
    .header {
        display: flex;
        flex-direction: row;
        align-items: center;
        gap: 5px;

        border-bottom: 1px solid var(--fg-color);
        padding: 5px;
        margin: 5px 5px 10px 5px;
    }

    .header-right {
        margin-left: auto;
    }

    .title {
        font-size: 2em;
        font-weight: bold;
    }
</style>