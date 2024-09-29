<script lang="ts">
	import Header from "$lib/components/Header.svelte";
    import "$lib/styles.css";

</script>

<Header />
<div style="margin: 15px">
    <slot></slot>
</div>