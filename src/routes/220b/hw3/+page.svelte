<script>
    import { pageTitle, course } from "$lib";
    import Audio from "$lib/components/Audio.svelte";
    import Link from "$lib/components/Link.svelte";
    import Section from "$lib/components/Section.svelte";

    // remember to add to Header.svelte
    $pageTitle = "HW3";
    $course = "220b";
</script>

<Section title="HW3">
    <p style="font-size: 2em"><b><u>A Busy Summer Day</u></b></p>
    <Audio src="/hw3/audio.wav"></Audio>

    <Section sub title="Comments">
        <p>
            This piece takes you through a full summer day out in the meadows. It starts off with an
            echoing, somewhat longing melody, representing the time before the sun is fully up and
            the air is still cold. Then up comes the sun, and out come all the people with the
            banging of the percussion. The weather is great and children are running around playing
            in the fields. But eventually the sun goes back down again, and the fun ends, with just
            the howling of the winds and people hurrying home.
        </p>
        <p>
            I use all four of my ezInstruments, as well as one from my peer review partner Lara. My
            instruments are:
        </p>
        <ul>
            <li>
                <Link download="clank.ck" href="/hw3/clank.ck"><code>Clank</code></Link>: This uses
                granular synthesis with the original sample being me hitting a light pole with a
                rock. It also goes through a low pass filter controlled by an LFO, as well as a
                reverberator. It has kind of a bagpipe-y sound, and it's the primary instrument in
                the piece.
            </li>
            <li>
                <Link download="bew.ck" href="/hw3/bew.ck"><code>Bew</code></Link>: This is the
                instrument that sounds like a laser. It's a TriOsc connected to a comb filter,
                except that the frequency of the TriOsc is constantly decreased. It was a bit hard
                to fit this in with the piece due to its "futuristic" quality, and it sounds kind of
                silly, but that's okay.
            </li>
            <li>
                <Link download="pan.ck" href="/hw3/pan.ck"><code>FryingPan</code></Link>: The main
                percussion in this piece. It's just three different samples of me hitting a frying
                pan against a stove. The kick is slowed and put through a LPF to make it sound
                deeper. I also added the feature that the velocity controls the odds of the sample
                playing, in order to add some variance to the piece.
            </li>
            <li>
                <Link download="pan.ck" href="/hw3/pan.ck"><code>MouthClick</code></Link>: Literally
                just a sample of me clicking my tongue in my mouth, with a pitch shift. Has a small
                amount of variance in the volume of the played sample, in order to make it sound
                more "human".
            </li>
        </ul>
        <p>
            Lara's instrument is <code>airInst</code>, which makes the wind noises at the end. I
            really love the way it sounds, and I think it closes out the piece super nicely.
        </p>
    </Section>

    <Section sub title="Instructions">
        <p>
            <Link download="hw3.zip" href="/hw3/hw3.zip">Download source files</Link>
        </p>
        <p>
            To listen, just make sure you have SmucK installed and run <code>chuck main.ck</code>.
        </p>
    </Section>

    <Section sub title="Difficulties">
        <p>
            This project was pretty challenging in both the creative and technical departments.
            Creatively, I had a lot of trouble coming up with ideas for instruments. I did lots of
            experimenting with different filters and eventually settled on a few different things,
            but I feel like none of them are that outstanding in terms of novelty. Coming up with a
            coherent piece out of the instruments was also tough, since they have vastly different
            timbres and tones. Fitting them together was like trying to cook a meal using the last
            remaining leftovers in my fridge. I also blew up my ears several times while misusing
            filters. (Burnt the food?)
        </p>
        <p>
            On the technical side, I had a lot of fun using SmucK, but I also found it sometimes
            limiting. I had to split my piece up into separate parts that played one after another,
            since putting it all in one score seemed like a nightmare with the multiple instruments
            needing to have their rhythms lined up. I had lots of issues with using multiple players
            and parts getting cut off. In the final piece there's a problem with a lag spike when
            loading my instruments, resulting in a noticeable pop. Thankfully it's fine in the audio
            file.
        </p>
    </Section>

    <Section sub title="Peer Reviews">
        <p>
            I was in a group with Lara and Mollie. We met last Wednesday during office hours, and
            over Zoom on Saturday. The discussion was mostly focused on our instruments, since we
            hadn't had the time to work on the piece yet. I got some feedback on adjusting my
            instruments' sound, and while listening to my partners' instruments I was really
            inspired by Lara's airInst, so I included it in my piece. Overall, while we weren't able
            to provide feedback on the pieces directly, we were still each able to share our own
            expertise and help out with the instruments.
        </p>
    </Section>
</Section>
