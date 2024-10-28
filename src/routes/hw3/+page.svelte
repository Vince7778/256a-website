<script>
    import { pageTitle } from "$lib";
    import Image from "$lib/components/Image.svelte";
    import Section from "$lib/components/Section.svelte";

    // remember to add to Header.svelte
    $pageTitle = "HW3";
</script>

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
