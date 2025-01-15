<script lang="ts">
    import { canonLink } from "$lib";

    export let href: string;
    export let hide: boolean = false;
    export let download: string = "";
</script>

{#if download}
    <a href={$canonLink(href)} class:hidden-a={hide} {download}><slot /></a>
{:else}
    <a href={$canonLink(href)} class:hidden-a={hide}><slot /></a>
{/if}
