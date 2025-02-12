<script>
    import { pageTitle, course } from "$lib";
    import Link from "$lib/components/Link.svelte";
    import Section from "$lib/components/Section.svelte";
    import Video from "$lib/components/Video.svelte";

    // remember to add to Header.svelte
    $pageTitle = "HW2";
    $course = "220b";
</script>

<Section title="HW2">
    <div style="display: flex;">
        <pre style="padding-right: 15px;">
               _-_
            _-"   "-_
         _-"         "-_
      _-"               "-_
   _-"                     "-_
 ,"                           ",
 \    P E N T O R B I T A L    /
  \                           /
   \                         /
    \                       /
     \     2025-02-11      /
      \                   /
       \_________________/
        </pre>
    </div>

    <Video src="/hw2/hw2.mp4" w={1280} h={720} />
    <br />

    <Section sub title="Comments">
        <p>
            When I first saw this project I pretty much instantly knew that I wanted to use my
            drawing tablet. But since the tablet basically just maps to a mouse, and a mouse is too
            boring, I tried to make it unique by adding some physicality, with the paper "map" of
            where the notes are played. I thought it would be cool to drag the pen around and have
            that play the different notes. But then I was like, what if you also dragged the notes
            around? That's how I got the idea to have the objects playing the notes follow and orbit
            your cursor. Originally I wasn't going to have any graphics at all, but I needed some
            way to get the tablet input, and HID wasn't working on Mac.
        </p>

        <p>
            The four quadrants of the tablet area are four different pentatonic scales. I chose the
            scales randomly, which was probably a bad idea, but it adds some chaos when the squares
            start wandering around. Without user input the audio sounds random with a tiny bit of
            structure, but the user is able to bring it together by using the tablet, and then over
            time it devolves into chaos again. This is how the system controls its own development
            without the performer.
        </p>

        <p>
            It was a little tricky coming up with the way that the program dialogues with the
            performer. Typically the performer has near complete control with the pen down, and no
            control with the pen up. So I added an in between by making a mode where some of the
            squares randomly decide to disobey you and start wandering around. You still have
            control over most of the squares, but they kind of have their own free will too and can
            make dissonant sounds without your control.
        </p>
    </Section>

    <Section sub title="Instructions">
        <p>
            <Link download="hw2.zip" href="/hw2/hw2.zip">Download source files</Link>
        </p>
        <p>
            This program outputs no audio by itself; it instead sends notes to MIDI output. In my
            performance I hooked it up to Ableton Live, with four vibraphones. (The program uses
            multiple channels if the same note is playing at the same time.) Other than that, you
            can just run the program with <code>chuck main.ck</code>. You can use a mouse for input,
            but it was designed for use with a drawing tablet.
        </p>
    </Section>

    <Section sub title="Difficulties">
        <p>
            By far the hardest part about this project was getting the MIDI output to work in
            Ableton. I had an issue where Ableton was properly detecting the input, but for some
            reason it refused to actually send it to the instrument track. I still have no idea what
            was the problem; it fixed itself when I restarted my laptop.
        </p>
    </Section>
</Section>
