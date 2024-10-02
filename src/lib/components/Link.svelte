<script lang="ts">
    import { base } from "$app/paths";
    export let href: string;
    export let hide: boolean = false;
    export let download: string = "";
</script>

{#if download}
    <a href="{base}{href}" class:hidden-a={hide} {download}><slot /></a>
{:else}
    <a href="{base}{href}" class:hidden-a={hide}><slot /></a>
{/if}
