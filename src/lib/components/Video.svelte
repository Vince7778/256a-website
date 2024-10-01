<script lang="ts">
    import { base } from "$app/paths";
    export let src: string;
    export let w: number;
    export let h: number;
</script>

<video width={w} height={h} controls>
    <source src="{base}{src}" type="video/mp4">
    Your browser does not support the video tag.
</video>
