<script lang="ts">
    import { base } from "$app/paths";
    export let src: string;
    export let alt: string;

    // limit height to 200px
    export let limit: number = 0;
</script>

<div>
    <img class:limit={limit !== 0} style="--height-limit: {limit}px" src="{base}{src}" {alt} />
</div>

<style>
    div {
        max-width: 100%;
    }

    img {
        max-width: 100%;
        border: 1px solid var(--nt-color);
        border-radius: 5px;
    }

    .limit {
        max-height: var(--height-limit);
        width: auto;
        height: auto;
    }
</style>
