<script lang="ts">
    import Link from "./Link.svelte";
    import { pageTitle, devMode } from "$lib";
    import { goto } from "$app/navigation";
    import { base } from "$app/paths";

    function toggleDev() {
        $devMode = !$devMode;
    }

    // page title, nav name, url
    let navLinks = [
        ["", "Main", "/"],
        ["HW1", "HW1", "/hw1/"],
        ["HW2", "HW2", "/hw2/"],
        ["HW3", "HW3", "/hw3/"],
        ["RR1", "RR1", "/rr1/"],
        ["RR2", "RR2", "/rr2/"],
        ["RR3", "RR3", "/rr3/"],
        ["RR4", "RR4", "/rr4/"],
        ["RR5", "RR5", "/rr5/"],
    ];

    function handleNav(e: Event) {
        if (e.target) {
            const target = e.target as HTMLSelectElement;
            goto(base + target.value);
        }
    }
</script>

<svelte:head>
    <title>{$pageTitle || "256a"}</title>
</svelte:head>

<div class="header">
    <div class="title">
        <Link href="/" hide>Music 256A: Conor Kennedy</Link>
    </div>
    <div class="nav">
        <label for="pages">Go to: </label>
        <select name="pages" id="pages" on:change={handleNav}>
            {#each navLinks as link}
                <option value={link[2]} selected={$pageTitle == link[0]}>{link[1]}</option>
            {/each}
        </select>
    </div>
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

    .nav {
        margin-left: 10px;
    }
</style>
