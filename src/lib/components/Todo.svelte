<div class="outer-div">
    <div class="inner-div">TODO: <slot /></div>
</div>

<style>
    .outer-div {
        display: flex;
        margin-right: auto;
        border: 1px solid var(--nt-color);
    }

    .inner-div {
        background-color: yellow;
        color: black;
        border: 3px dashed black;
        padding: 5px;
    }
</style>
