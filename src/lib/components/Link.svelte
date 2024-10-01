<script lang="ts">
    import { base } from "$app/paths";
    export let href: string;
    export let hide: boolean = false;
</script>

<a href="{base}{href}" class:hidden-a={hide}><slot /></a>