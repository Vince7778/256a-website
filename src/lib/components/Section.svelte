<script lang="ts">
    export let title: string;
</script>

<div class="section">
    <div class="section-title">{title}</div>
    <div class="section-body">
        <slot></slot>
    </div>
</div>

<style>
    .section-title {
        font-size: 1.5em;
        font-weight: bold;
        margin-bottom: 5px;
    }

    .section-body {
        margin-left: 10px;
        padding: 5px 0px 5px 15px;
        border-left: 2px solid var(--fg-color);
    }

    @media only screen and (min-width: 720px) {
        .section-body {
            max-width: 70%;
        }
    }
</style>