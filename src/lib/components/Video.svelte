<script lang="ts">
    import { base } from "$app/paths";
    export let src: string;
    export let w: number;
    export let h: number;
    export let type: string = "video/mp4";
</script>

<video width={w} height={h} controls>
    <source src="{base}{src}" {type} />
    Your browser does not support the video tag.
</video>
