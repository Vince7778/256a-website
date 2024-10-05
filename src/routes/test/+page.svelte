<script>
    import Section from "$lib/components/Section.svelte";
    import { pageTitle } from "$lib";
    import Quote from "$lib/components/Quote.svelte";

    $pageTitle = "test";
</script>

<Section title="Part 1: Reading Response">
    <Section sub title="subsection">hello!</Section>
    <p>Hello, I am testing that the styles of paragraphs are proper.</p>
    <p>This isn't too close, right? Or too far?</p>
    <Quote citation="Conor Kennedy, 2024">
        This is a quote! <i>There are italics in my quote!</i>
    </Quote>
</Section>
<Section title="Part 2: Design Etude">
    <p>Another section! Yay!</p>
</Section>
