<script lang="ts">
    import { canonLink } from "$lib";
    export let src: string;
    export let w: number;
    export let h: number;
    export let type: string = "video/mp4";
</script>

<video width={w} height={h} controls>
    <source src={$canonLink(src)} {type} />
    Your browser does not support the video tag.
</video>
