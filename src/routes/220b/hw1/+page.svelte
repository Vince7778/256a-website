<script>
    import { pageTitle, course } from "$lib";
    import Audio from "$lib/components/Audio.svelte";
    import Link from "$lib/components/Link.svelte";
    import Section from "$lib/components/Section.svelte";

    // remember to add to Header.svelte
    $pageTitle = "HW1";
    $course = "220b";
</script>

<Section title="HW1">
    <p style="font-size: 2em"><b><u>chime forest</u></b></p>
    <Audio src="/hw1/audio1.wav" />
    <Audio src="/hw1/audio2.wav" />
    <br />

    <Section sub title="Instructions">
        <p>
            wake up early on a windy morning<br />
            hang 10 wind chimes on trees in the forest<br />
            stand in the middle and listen
        </p>
    </Section>

    <Section sub title="Reflection">
        <p>
            <Link download="hw1.zip" href="/hw1/hw1.zip">Download source files</Link>
        </p>

        <p>To run: chuck main1.ck or chuck main2.ck</p>

        <p>
            There are two main sounds in the programs: the chimes, and the wind. Given the
            instructions, I think these two sources are the most important, and I didn't want to
            overcomplicate things with other noises. Program 1 has the wind increase then decrease
            in intensity over time, while program 2 has the wind randomly increase and decrease in
            intensity, leading to a more chaotic sound. The chimes react to the wind's intensity,
            becoming louder and more frequent the stronger the wind is.
        </p>

        <p>
            I used additive synthesis to create the chime noises, by looking at the spectrum plot of
            a sample. I also used the spatializer I had written for my MUSIC 256a final project, so
            each set of chimes has a consistent location. I didn't really encounter any
            difficulties; I just spent a long time fine-tuning how the chimes react to the wind.
        </p>
    </Section>
</Section>
