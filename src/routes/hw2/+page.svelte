<script>
    import Section from "$lib/components/Section.svelte";
    import { pageTitle } from "$lib";
    import Image from "$lib/components/Image.svelte";
    import Video from "$lib/components/Video.svelte";
    import Link from "$lib/components/Link.svelte";

    // remember to add to Header.svelte
    $pageTitle = "HW2";
</script>

<Section title="Milestone">
    <p style="font-size: 2em"><b><u>Storm</u></b></p>
    <p>
        This audio visualizer is themed around a magical lightning storm. The sound frequencies are
        represented by the swelling ground underneath, and with sudden impacts in the audio, a bolt
        of lightning will strike, illuminating the ground underneath.
    </p>
    <Section sub title="Screenshots">
        <div id="captures">
            <Image src="/hw2/vis_ss1.png" alt="visualizer screenshot 1" limit={250} />
            <Image src="/hw2/vis_ss2.png" alt="visualizer screenshot 2" limit={250} />
            <Image src="/hw2/vis_ss3.png" alt="visualizer screenshot 3" limit={250} />
            <Image src="/hw2/vis_ss4.png" alt="visualizer screenshot 4" limit={250} />
        </div>
    </Section>
    <Section sub title="Reflection">
        <p>
            My main takeaway from this milestone is that translating your thoughts to code is REALLY
            hard. The way I had envisioned this project in my head is not really at all how it
            actually turned out. I think that given more time I could get closer to what I want, but
            there are more fundamental things that were issues as well. For instance, getting the
            peaks of the audio algorithmically turns out to be a really hard problem, and I also ran
            into performance issues with the sheer amount of shapes I was creating. Thus, I'm not
            sure I can consider my design artful yet, but hopefully I can improve it for the final
            product.
        </p>
    </Section>
    <Video src="/hw2/visualizer_demo.mp4" w={1280} h={720} />
    <Section sub title="Downloads">
        <p>
            <Link href="/hw2/storm_milestone.ck" download="conork_hw2_milestone.ck"
                >Download ChucK file here</Link>
        </p>
        <p>
            <Link href="/hw2/demo.wav" download="conork_hw2_milestone_audio.wav"
                >Download demo audio here</Link>
        </p>
    </Section>
</Section>

<style>
    #captures {
        display: flex;
        flex-direction: row;
        flex-wrap: wrap;
        gap: 0 5px;
    }
</style>
