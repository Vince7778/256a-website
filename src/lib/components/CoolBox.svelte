<div class="coolbox">
    <slot />
</div>

<style>
    .coolbox {
        display: flex;
        flex-direction: column;
        gap: 1em;

        border: 1px solid var(--nt-color);
        border-radius: 5px;
        background-color: var(--bg-color-l);
        padding: 8px;
    }
</style>
