<script>
    import Section from "$lib/components/Section.svelte";
    import { pageTitle } from "$lib";
    import Image from "$lib/components/Image.svelte";
    import Video from "$lib/components/Video.svelte";
    import Link from "$lib/components/Link.svelte";

    // remember to add to Header.svelte
    $pageTitle = "HW2";
</script>

<Section title="HW2: Sound Peeking">
    <p style="font-size: 2em"><b><u>Storm</u></b></p>
    <Video src="/hw2/hw2_final.mp4" w={1280} h={720} />
    <p>
        This audio visualizer is themed around a magical lightning storm. The sound frequencies are
        represented by the swelling ground, and with sudden impacts in the audio, a bolt of
        lightning will strike, illuminating the ground underneath.
    </p>
    <Section sub title="Screenshots">
        <div id="captures">
            <Image src="/hw2/vis_final_ss1.png" alt="visualizer final screenshot 1" limit={250} />
            <Image src="/hw2/vis_final_ss2.png" alt="visualizer final screenshot 2" limit={250} />
            <Image src="/hw2/vis_final_ss3.png" alt="visualizer final screenshot 3" limit={250} />
            <Image src="/hw2/vis_final_ss4.png" alt="visualizer final screenshot 4" limit={250} />
        </div>
    </Section>
    <Section sub title="Instructions">
        <p>
            No special instructions or controls, just make sure you run with the thunder.wav file in
            the same folder!
        </p>
    </Section>
    <Section sub title="Download">
        <p>
            <Link href="/hw2/storm.ck" download="conork_hw2.ck">Download ChucK file here</Link>
        </p>
        <p>
            <Link href="/hw2/thunder.wav" download="thunder.wav">Download thunder.wav here</Link>
        </p>
    </Section>
    <Section sub title="Final Reflection">
        <p>
            The biggest difference between this final version and the milestone is that I removed a
            lot of the background, simplifying things greatly. Now it's just a rainbow road floating
            in space, which I think looks pretty cool. (Definitely got some of that Mario Kart
            vibe!) I knew from the start that I wanted there to be at least one big shift in the
            visualizer, so I first made the audio go from minor to major, then came up with the
            graphics to go with it. I tried out a few different things (including making it daytime)
            but I settled on just adding a starry sky and lightening the clouds, as if the storm was
            letting up. I'm really happy with the way it turned out, but of course there are still
            things I would improve on but don't have time, like decorating the sky a little more,
            and adding more elements to the music.
        </p>
        <p>
            I feel like coming up with ideas for this part was a lot easier than for the milestone.
            I think most of the difficulty with the milestone came from brainstorming something, but
            here I was able to just build on top of what I already had.
        </p>
        <p>
            I think the biggest difficulty here was the coding. The file ended up being really long
            (over 1,000 lines!) and it gets really unwieldy to look through all that code to tweak
            something. I'm sure that if I were to return to this code in a month I wouldn't have a
            clue what's going on. I tried initially to separate my code into multiple files (an
            audio file and visuals file) but quickly realized that it was too limited to do what I
            want. For instance it's difficult to use multiple classes in both files. I also had some
            trouble with audio synthesis, notably a few times accidentally setting the gain of an
            instrument really high and destroying my eardrums.
        </p>
        <p>
            I'd like to thank Kunwoo and Andrew for helping me at office hours. I rarely ever go to
            office hours of any kind, but a couple weeks ago I decided to stop by and I definitely
            do not regret it. They really helped jumpstart this project and gave me lots of
            motivation!
        </p>
    </Section>
</Section>

<Section title="Milestone">
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
