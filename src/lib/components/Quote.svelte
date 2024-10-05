<script lang="ts">
    export let citation: string = "";
</script>

<div class="quote">
    <div class="quote-body">
        <slot />
    </div>
    {#if citation}
        <div>
            —{citation}
        </div>
    {/if}
</div>

<style>
    .quote {
        display: flex;
        flex-direction: column;
        gap: 1em;

        margin-left: 10px;
        padding: 8px 0px 5px 15px;
        border-left: 4px solid var(--fg-color-t);
    }

    .quote-body {
        font-style: italic;
    }

    .quote-body :global(i) {
        font-style: normal;
    }
</style>
