<script lang="ts">
    import { base } from "$app/paths";
    import { course } from "$lib";
    export let src: string;
    export let loop: boolean = false;
</script>

<audio controls {loop}>
    <source src="{base}/{$course}{src}" type="audio/mp3" />
    Your browser does not support the audio element.
</audio>
