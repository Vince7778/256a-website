<script>
    import { pageTitle, course } from "$lib";
    $course = "256a";
    import Image from "$lib/components/Image.svelte";
    import Link from "$lib/components/Link.svelte";
    import Section from "$lib/components/Section.svelte";
    import Video from "$lib/components/Video.svelte";

    // remember to add to Header.svelte
    $pageTitle = "HW3";
</script>

<Section title="HW3: Interactive AudioVisual Music Sequencer">
    <p style="font-size: 2em"><b><u>Falls</u></b></p>
    <p>Cascades of sound emerge as magical waterfalls descend down a maze of platforms.</p>
    <Video src="/hw3/hw3_final.mp4" w={1280} h={720} />

    <Section sub title="Screenshots">
        <div id="captures">
            <Image src="/hw3/seq_final_ss1.png" alt="sequencer final screenshot 1" limit={250} />
            <Image src="/hw3/seq_final_ss2.png" alt="sequencer final screenshot 2" limit={250} />
            <Image src="/hw3/seq_final_ss3.png" alt="sequencer final screenshot 3" limit={250} />
            <Image src="/hw3/seq_final_ss4.png" alt="sequencer final screenshot 4" limit={250} />
        </div>
    </Section>

    <Section sub title="Instructions">
        <p>
            <Link href="/hw3/falls.ck" download="conork_hw3_final.ck"
                >Download ChucK file here</Link>
        </p>
        <p>
            Use the toolbox in the lower left to place sources and platforms. Arrow keys change the
            platform's pitch (and hue). Press backspace for a shortcut to delete objects.
        </p>
    </Section>

    <Section sub title="Reflection">
        <p><i>Make sure you watch the video before you read this! (Spoilers!)</i></p>
        <p>
            A lot has changed, and a lot hasn't changed from the milestone. I kept the waterfall of
            course, but instead of sweeping from left to right in a fixed way, you have a lot more
            control by placing them yourself and choosing their rhythm. Many people had the feedback
            that there should be multiple streams, so I wanted to satisfy that.
        </p>
        <p>
            The screen rotation idea basically came out of nowhere. I noticed that my original code
            for calculating the waterfall relied heavily on hard-coding the direction of gravity,
            and I wondered to myself if I could have the falls go in whatever direction I wanted.
            After some work (and lots of debugging) I managed to get it to work. I went through a
            few iterations of this gravity-changing mechanic, and I finally settled on this whole
            screen rotation idea as kind of a way of breaking the fourth wall. I was really excited
            when I came up with this idea, and I think it turned out really well. I know tons of
            people wanted to see the screen fill up with water, but I feel like that would be too
            expected, so I tried to come up with something new. I think literally nobody will expect
            something like this to happen.
        </p>
        <p>
            I can't think of any specific thing that was difficult to do in this project. My main
            obstacle was coming up with good ideas; a bunch of times I coded something and then
            decided to throw it away since it didn't really fit or didn't feel reasonable to
            complete. The worst part of coding this was figuring out all the geometry code for
            calculating the collision and gravity of the waterfall. I have to estimate that 20-30%
            of the overall time was spent just doing that.
        </p>
        <p>
            If I had more time, I would implement a drum instrument and improve shortcuts. I was
            halfway through implementing drums when I started to really not like the way I was
            implementing them, so I discarded it (and came up with the gravity idea instead). I also
            don't like how arrow keys are the only way to change pitch, but I didn't have time to
            think of or implement a better system.
        </p>
        <p>
            In terms of system design, I've spent too much time using non-object-oriented languages
            (Rust my beloved) so the architecture is probably a bit of a mess. Here's my attempt at
            explaining it:
        </p>
        <Image src="/hw3/diagram.png" alt="diagram of code architecture" />
        <p>
            Really quick: Platforms create CircleMakers when hit by waterfalls, which make Circles.
            Sources generate one waterfall each and calculate its path as a set of
            WaterfallSegments, which interact with Platforms. There is also a global RhythmControl
            which attaches to a Source and controls its rhythm. A set of tools and a toolbox are
            created using GGens. Both Platforms and Sources are Deleteable, which lets them be
            deleted by the delete tool.
        </p>
        <p>
            I didn't collaborate with anyone on this project (and was too busy to go to office
            hours), but I definitely appreciated the feedback from the milestone, so thanks to
            everyone in the class for that.
        </p>
    </Section>
</Section>

<Section title="Milestone B: Something Working">
    <Video src="/hw3/hw3_milestone.mp4" w={1280} h={720} />

    <Section sub title="Download">
        <p>
            <Link href="/hw3/falls-milestone.ck" download="conork_hw3_milestone.ck"
                >Download ChucK file here</Link>
        </p>
    </Section>
</Section>

<Section title="Milestone A: Research + Preliminary Design">
    <Section sub title="Research">
        <p>
            What I learned from my research is that "music sequencer" is a lot more broad of a term
            than I realized. For instance, a piano roll is a music sequencer, and so is something
            like a sheet music or score editor. I've used score editors lots before, but I never
            would have called it a music sequencer.
        </p>
        <p>
            I found <a href="https://news.ycombinator.com/item?id=14212054">this Hacker News post</a
            >, which is a dude who created his own sequencer design. It looks like just a regular
            music sequencer, but someone in the comments linked one of this own, which
            <a href="http://composerssketchpad.com/">looks pretty cool!</a>
            A lot more in line with what we would maybe design for this project, though maybe too simple
            of a concept. You can just draw the notes and have them play.
        </p>
        <p>
            There was also <a href="https://medlylabs.com/">this one</a>, which is also more like a
            traditional sequencer, but the design of this one looks very clean. It's almost
            certainly less customizable than your usual DAW, but it looks a lot simpler to
            understand, and it's marketed as being very beginner-friendly.
        </p>
    </Section>
    <Section sub title="Design 1: Falls">
        <Image limit={480} src="/hw3/hw3_sketch1.png" alt="sketch of design 1" />
        <p>(Sorry that this sketch is digital, I feel like I can't express it as well on paper!)</p>
        <p>
            The main idea of this one is that the playhead is a stream of water, falling down and
            hitting the platforms. When struck, the platform emits a tone based on its pitch. The
            playhead sweeps left to right, changing the path of the water as it goes and thus
            causing different sets of pitches to play.
        </p>
        <p>
            I feel like this design has a lot of potential depth to it. You can create rhythm by
            having the water strike new platforms at regular intervals, and it's an interesting
            puzzle to create chords with platforms dropping water onto one another. I could also add
            more aspects, for instance having the volume of the pitch be determined by how far the
            water falls onto it. The gear icon you can see in the toolbar is meant to be a water
            wheel, and it's my concept of how drum sounds can be played, by spinning the water wheel
            for a short time as it passes by.
        </p>
    </Section>
    <Section sub title="Design 2: Wheels">
        <Image limit={480} src="/hw3/hw3_sketch2.png" alt="sketch of design 2" />
        <p>
            For this one, I was inspired by the way that gear ratios work. For example, if one gear
            is turning against another and is 4 times its size, then the smaller one will be
            spinning at 4 times the rate. I think these nice ratios have a lot of potential with
            rhythm. In this design, we play a sound when a wheel completes a full revolution. We
            allow the user to place new wheels against one another, control the size of the wheel,
            and control what sound a wheel makes. I believe this will allow them to create
            interesting rhythms and loops using the size ratios. You can control the tempo by
            controlling the speed of the center driver wheel.
        </p>
    </Section>
    <Section sub title="Design 3: hungry">
        <Image limit={480} src="/hw3/hw3_sketch3.jpg" alt="sketch of design 3" />
        <p>
            The main idea of this one is that there are these little box guys going around eating
            the fruits that grow. Every time they eat a fruit it makes a noise. Players can place
            fruits, remove fruits, and spawn the box guys. Box guys go around eating fruits, and
            they always go to the nearest fruits. Fruits regrow after a short time.
        </p>
        <p>
            This design could lead to interesting, but freeform, sound. Since the boxes go to the
            nearest fruits, users can control their paths, but there is also some interesting
            interaction if two boxes go for the same fruit. It would also sound cool if there are
            lots of boxes and fruits and lots of noise is being made.
        </p>
        <p>This design is three-dimensional, so users can walk around and plant the fruits.</p>
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
