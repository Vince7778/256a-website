<script>
    import { pageTitle, course } from "$lib";
    import Image from "$lib/components/Image.svelte";
    import Link from "$lib/components/Link.svelte";
    import Section from "$lib/components/Section.svelte";

    // remember to add to Header.svelte
    $pageTitle = "HW4";
    $course = "220b";
</script>

<Section title="HW4">
    <p style="font-size: 2em"><b><u>Dispersion</u></b></p>
    <a href="https://vimeo.com/1066056384?share=copy#t=6828.238"
        >Link to performance (starts at 1:53:59)</a>
    <script src="https://player.vimeo.com/api/player.js"></script>
    <div style="padding:56.25% 0 0 0;position:relative;">
        <iframe
            src="https://player.vimeo.com/video/1066056384?badge=0&amp;autopause=0&amp;player_id=0&amp;app_id=58479"
            frameborder="0"
            allow="autoplay; fullscreen; picture-in-picture; clipboard-write; encrypted-media"
            style="position:absolute;top:0;left:0;width:100%;height:100%;"
            title="220B Final Projects"></iframe>
    </div>

    <Section sub title="Comments">
        <p>This piece brings you to a colorful dance floor tuned to the music.</p>
        <p>
            This was, like, my third different idea for this project. I completely discarded the
            stuff I had for my milestone and went for this instead, and I'm glad because I don't
            think my milestone ideas were solid enough to make something beautiful.
        </p>
        <p>
            The main inspiration for this piece was the ChuGL example file
            <a href="https://chuck.stanford.edu/chugl/examples/deep/game_of_life.ck"
                >game_of_life.ck</a
            >. I was learning how to make my own shaders, and I thought this example was really
            cool. I remember in middle school being really interested in cellular automata, so I
            wanted to make my own synced to the music. I actually started with the visuals, and when
            it looked kind of ethereal, I made that the vibe of the music, along with hard beats
            because I like hard beats.
        </p>
        <p>
            I don't do any sound synthesis in ChucK; it's all done in Ableton. I used lots of
            filters and effects controlled by the user, and synced it to the visuals. I did this
            because I was most familiar with Ableton for making this kind of music, and I found it
            difficult to route the audio back to ChucK. Also, I wanted to learn how to use the
            session view and make an actual performance within Ableton controlled by my MIDI
            keyboard.
        </p>
        <p>
            This project was super fun! I especially found it interesting writing my own shader; I
            had never done this before and seeing the result was really cool. A lot of people were
            surprised after my performance that I had written this in ChuGL, so it makes me glad
            that I was able to use this tool in a special way. I was really nervous during my
            performance, especially with the improvisation part because I had never done piano
            soloing before (I played trumpet solos in my high school's jazz band). I think I did OK,
            though it's definitely nothing professional. It was a great experience stepping outside
            my comfort zone.
        </p>
        <p>
            Also I'm quite proud of the code I wrote. I made sure to add lots of comments explaining
            the weird stuff, and I think I designed it quite well. Definitely check it out!
        </p>
    </Section>

    <Section sub title="Instructions">
        <p>
            <Link download="hw4.zip" href="/hw4/hw4.zip">Download source files</Link>
        </p>
        <p>
            This folder contains the Ableton Live set and the ChucK code. I'm using a Mac so I can't
            guarantee it'll work on other systems. To set up the MIDI, go to Audio MIDI Setup and
            use an IAC driver, so that Ableton can communicate with ChucK. My MIDI keyboard is an
            Akai MPK Mini III. In Ableton, make sure in Settings that MIDI input is from the
            keyboard, and that it outputs to the IAC driver. In ChucK, make sure that the IAC driver
            is device 0, and the MIDI keyboard is device 1.
        </p>
        <Image
            src="/hw4/ableton_midi.png"
            alt="The Ableton MIDI configuration I used"
            limit={300} />
    </Section>

    <Section sub title="Difficulties">
        <p>
            Like I mentioned, I went through multiple ideas before I settled on this one. My earlier
            ideas were missing the crucial element that this was meant to be a performance, and I
            found this to be the hardest requirement to follow since I had never done a computer
            music performance before. What I ended up doing is more of a traditional performance
            with me playing the instrument, which maybe isn't the most creative thing but it is what
            I am used to.
        </p>
        <p>
            I spent a lot of time working on the shader, despite how basic it is. This is partially
            due to me iterating on it a lot until it looked nice. But also, ChuGL's documentation on
            shaders is very sparse (understandably), and I had to do some digging through the actual
            source code to find out what stuff like a <code>VertexOutput</code> is. I also had never
            written a shader before, so that only made it harder. I'm lucky that I didn't have to write
            a vertex shader, only a fragment shader.
        </p>
        <p>
            I also ran into some slight performance issues with the cellular automaton. I used a
            weird approach where I only calculated part of the grid at a time, to avoid audio bugs.
            This added some extra complexity. I know game_of_life.ck uses a compute shader, but that
            seemed even more difficult to do.
        </p>
    </Section>

    <p>
        Thank you Celeste for teaching this class! I had a lot of fun this quarter, and learned so
        much about computer music and algorithms. I'm so grateful to be able to go to CCRMA and take
        these special kinds of classes that connect my major (computer science) and my interests
        (music). I'll definitely continue using ChucK in the future!
    </p>
</Section>
